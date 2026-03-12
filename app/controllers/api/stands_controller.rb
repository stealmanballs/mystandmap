# frozen_string_literal: true

class Api::StandsController < ApplicationController
  # Return stands within a radius from a center point
  def nearby
    lat = params[:lat].to_f
    lng = params[:lng].to_f
    radius_miles = params[:radius].to_i || 25
    product_filter = params[:filter].to_s.downcase
    
    # Convert miles to kilometers for geocoder
    radius_km = radius_miles * 1.60934
    
    # Get stands within bounding box first (performance)
    lat_range = radius_km / 111.0  # ~111km per degree latitude
    lng_range = radius_km / (111.0 * Math.cos(lat * Math::PI / 180))
    
    stands = Stand.where(
      latitude: (lat - lat_range)..(lat + lat_range),
      longitude: (lng - lng_range)..(lng + lng_range)
    )
    
    # Filter by product if specified
    if product_filter.present?
      stands = stands.where("products_text ILIKE ?", "%#{product_filter}%")
    end
    
    # Calculate distance and filter
    stands = stands.select do |stand|
      if stand.latitude && stand.longitude
        distance = haversine_distance(lat, lng, stand.latitude, stand.longitude)
        distance <= radius_miles
      else
        false
      end
    end
    
    # Sort by distance
    stands = stands.sort_by do |stand|
      haversine_distance(lat, lng, stand.latitude, stand.longitude)
    end
    
    # Limit to reasonable number
    stands = stands.first(100)
    
    # Add distance to each stand
    stands = stands.map do |stand|
      stand_hash = stand.as_json(only: [:id, :name, :city, :state, :zip, :latitude, :longitude, 
                                        :products_text, :hours_text, :phone, :email, :verified,
                                        :stand_type, :address_1])
      stand_hash[:distance] = haversine_distance(lat, lng, stand.latitude, stand.longitude)
      stand_hash[:full_address] = stand.full_address
      stand_hash
    end
    
    render json: stands
  end
  
  private
  
  # Haversine formula to calculate distance between two points
  def haversine_distance(lat1, lon1, lat2, lon2)
    r = 3959  # Earth's radius in miles
    
    dlat = (lat2 - lat1) * Math::PI / 180
    dlon = (lon2 - lon1) * Math::PI / 180
    
    a = Math.sin(dlat/2) * Math.sin(dlat/2) +
        Math.cos(lat1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) *
        Math.sin(dlon/2) * Math.sin(dlon/2)
    
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    
    r * c
  end
end
