# frozen_string_literal: true

class StandsController < ApplicationController
  before_action :set_stand, only: [:show]
  
  def index
    @stands = Stand.all
    
    if params[:search].present?
      @stands = @stands.where("name ILIKE ? OR city ILIKE ? OR products_text ILIKE ?", 
                             "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end
    
    if params[:stand_type].present?
      @stands = @stands.where(stand_type: params[:stand_type])
    end
    
    if params[:city].present?
      @stands = @stands.where("city ILIKE ?", "%#{params[:city]}%")
    end
    
    @stands = @stands.order(updated_at: :desc).limit(100)
  end
  
  def show
    @stand = Stand.find(params[:id])
  end
  
  private
  
  def set_stand
    @stand = Stand.find(params[:id])
  end
end
