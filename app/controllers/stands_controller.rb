# frozen_string_literal: true

class StandsController < ApplicationController
  before_action :set_stand, only: [:show]
  
  def index
    # Try to get cached stands list
    cache_key = "stands_list_#{params[:search]}_#{params[:stand_type]}_#{params[:city]}"
    
    @stands = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      stands = Stand.all
      
      if params[:search].present?
        stands = stands.where("name ILIKE ? OR city ILIKE ? OR products_text ILIKE ?", 
                               "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
      end
      
      if params[:stand_type].present?
        stands = stands.where(stand_type: params[:stand_type])
      end
      
      if params[:city].present?
        stands = stands.where("city ILIKE ?", "%#{params[:city]}%")
      end
      
      stands = stands.order(updated_at: :desc).limit(100)
      
      # Eager load photos to avoid N+1
      stands = stands.includes(photo_attachment: :blob) if stands.respond_to?(:includes)
      
      stands
    end
  end
  
  def map
    # Default center: Wisconsin
    @center_lat = params[:lat].presence&.to_f || 43.7844
    @center_lng = params[:lng].presence&.to_f || -88.7879
  end
  
  def show
    # Cache individual stand with cache key based on updated_at
    cache_key = "stand_#{params[:id]}_#{@stand.updated_at.to_i}"
    
    @stand = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      @stand
    end
  end
  
  private
  
  def set_stand
    @stand = Stand.find(params[:id])
  end
end
