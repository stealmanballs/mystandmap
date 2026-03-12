# frozen_string_literal: true

class Farmer::StandsController < ApplicationController
  before_action :authenticate_farmer!
  before_action :load_farmer_stand, only: [:edit, :update]
  
  def new
    @stand = Stand.new
  end
  
  def create
    @stand = Stand.new(stand_params)
    if @stand.save
      # Create automatic approval for farmer-created stands
      if current_user.farmer?
        @stand.claims.create(user: current_user, status: 'approved')
        @stand.update(claimed: true)
      end
      redirect_to farmer_dashboard_path, notice: "Stand created successfully!"
    else
      flash.now[:alert] = @stand.errors.full_messages.join(", ")
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @stand.update(stand_params)
      redirect_to farmer_dashboard_path, notice: "Stand updated successfully!"
    else
      flash.now[:alert] = @stand.errors.full_messages.join(", ")
      render :edit
    end
  end
  
  private
  
  def load_farmer_stand
    # Only find stands where user has an approved claim
    @stand = current_user.stands.approved.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to farmer_dashboard_path, alert: "Stand not found or access denied."
  end
  
  def stand_params
    params.require(:stand).permit(:name, :description, :stand_type, :address_1, :address_2, 
                                  :city, :state, :zip, :phone, :email, :website_url, 
                                  :facebook_url, :hours_text, :products_text, :open_now_override, :verified,
                                  photos: [])
  end
end
