# frozen_string_literal: true

class Admin::StandsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @stands = Stand.order(created_at: :desc).paginate(page: params[:page], per_page: 50)
  end
  
  def edit
    @stand = Stand.find(params[:id])
  end
  
  def update
    @stand = Stand.find(params[:id])
    if @stand.update(stand_params)
      redirect_to admin_dashboard_path, notice: "Stand updated!"
    else
      render :edit
    end
  end
  
  def destroy
    @stand = Stand.find(params[:id])
    @stand.destroy
    redirect_to admin_dashboard_path, notice: "Stand deleted."
  end
  
  def import
    @recent_imports = ImportBatch.order(created_at: :desc).limit(10)
  end
  
  def import_csv
    if params[:file].blank?
      redirect_to import_admin_stands_path, alert: "Please select a file."
      return
    end
    
    # Validate file type
    unless params[:file].content_type.in?(['text/csv', 'application/csv', 'text/comma-separated-values'])
      redirect_to import_admin_stands_path, alert: "Please upload a CSV file."
      return
    end
    
    # Validate file extension as additional check
    unless params[:file].original_filename.end_with?('.csv')
      redirect_to import_admin_stands_path, alert: "Please upload a file with .csv extension."
      return
    end
    
    # Validate CSV headers
    begin
      headers = CSV.read(params[:file].path, encoding: 'UTF-8').first
      unless headers.present?
        redirect_to import_admin_stands_path, alert: "CSV file appears to be empty."
        return
      end
    rescue => e
      redirect_to import_admin_stands_path, alert: "Could not parse CSV file: #{e.message}"
      return
    end
    
    # Create import batch record
    import_batch = ImportBatch.create!(
      file_name: params[:file].original_filename,
      status: 'processing',
      user: current_user,
      started_at: Time.current
    )
    
    imported_count = 0
    failed_count = 0
    duplicate_count = 0
    error_summary = []
    
    CSV.foreach(params[:file].path, headers: true, encoding: 'UTF-8') do |row|
      row_number = $.
      
      begin
        # Skip empty rows
        next if row.to_h.values.all?(&:blank?)
        
        name = row['stand_name'] || row['name']
        address = row['address']
        city = row['city']
        
        # Check for duplicates (by name + city)
        existing = Stand.where('LOWER(name) = ? AND LOWER(city) = ?', 
                              name.to_s.downcase, city.to_s.downcase).exists?
        if existing
          duplicate_count += 1
          import_batch.import_errors.create!(
            row_number: row_number,
            row_data: row.to_h.to_json,
            error_message: "Duplicate stand: #{name} in #{city}",
            error_type: 'duplicate'
          )
          next
        end
        
        # Validate required fields
        unless name.present? && city.present?
          failed_count += 1
          import_batch.import_errors.create!(
            row_number: row_number,
            row_data: row.to_h.to_json,
            error_message: "Missing required fields: name and city",
            error_type: 'validation'
          )
          next
        end
        
        stand_data = {
          name: name,
          address_1: address,
          city: city,
          state: row['state'] || 'WI',
          zip: row['zip'],
          latitude: row['latitude'],
          longitude: row['longitude'],
          stand_type: row['stand_type'] || row['type'],
          products_text: row['products_available'] || row['products'],
          hours_text: row['open_hours'] || row['hours'],
          phone: row['contact_phone'],
          email: row['contact_email'],
          website_url: row['website_or_facebook'],
          source: 'csv_import'
        }
        
        stand = Stand.new(stand_data)
        stand.slug = stand.name.to_s.parameterize if stand.name.present?
        
        if stand.save
          imported_count += 1
        else
          failed_count += 1
          error_msg = stand.errors.full_messages.join(', ')
          import_batch.import_errors.create!(
            row_number: row_number,
            row_data: row.to_h.to_json,
            error_message: error_msg,
            error_type: 'validation'
          )
        end
      rescue => e
        failed_count += 1
        import_batch.import_errors.create!(
          row_number: row_number,
          row_data: row.to_h.to_json,
          error_message: e.message,
          error_type: 'error'
        )
      end
    end
    
    # Update import batch
    import_batch.update!(
      status: failed_count == 0 ? 'completed' : 'completed_with_errors',
      imported_count: imported_count,
      failed_count: failed_count,
      duplicate_count: duplicate_count,
      completed_at: Time.current,
      error_summary: error_summary.join("\n") if error_summary.any?
    )
    
    redirect_to admin_dashboard_path, 
      notice: "Import complete: #{imported_count} imported, #{duplicate_count} duplicates, #{failed_count} failed."
  end
  
  private
  
  def stand_params
    params.require(:stand).permit(:name, :description, :stand_type, :address_1, :address_2,
                                  :city, :state, :zip, :latitude, :longitude, :phone, 
                                  :email, :website_url, :facebook_url, :google_maps_url,
                                  :hours_text, :products_text, :open_now_override, :verified, :claimed,
                                  photos: [])
  end
end
