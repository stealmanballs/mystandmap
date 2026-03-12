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
  end
  
  def import_csv
    if params[:file].blank?
      redirect_to import_admin_stands_path, alert: "Please select a file."
      return
    end
    
    imported_count = 0
    failed_count = 0
    errors = []
    
    CSV.foreach(params[:file].path, headers: true, encoding: 'UTF-8') do |row|
      begin
        stand_data = {
          name: row['stand_name'] || row['name'],
          address_1: row['address'],
          city: row['city'],
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
          errors << "Row #{$.}: #{stand.errors.full_messages.join(', ')}"
        end
      rescue => e
        failed_count += 1
        errors << "Row #{$.}: #{e.message}"
      end
    end
    
    if imported_count > 0
      redirect_to admin_dashboard_path, notice: "Imported #{imported_count} stands. #{failed_count} failed."
    else
      redirect_to import_admin_stands_path, alert: "Import failed. #{failed_count} errors."
    end
  end
  
  private
  
  def stand_params
    params.require(:stand).permit(:name, :description, :stand_type, :address_1, :address_2,
                                  :city, :state, :zip, :latitude, :longitude, :phone, 
                                  :email, :website_url, :facebook_url, :google_maps_url,
                                  :hours_text, :products_text, :open_now_override, :verified, :claimed)
  end
end
