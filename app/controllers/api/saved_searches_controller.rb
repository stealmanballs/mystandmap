# frozen_string_literal: true

class Api::SavedSearchesController < ApplicationController
  before_action :authenticate_user!
  
  # GET /api/saved_searches
  def index
    searches = current_user.saved_searches.order(created_at: :desc)
    render json: searches.map { |s| search_json(s) }
  end
  
  # POST /api/saved_searches
  def create
    search = current_user.saved_searches.build(search_params)
    search.criteria = criteria_params
    
    if search.save
      render json: search_json(search), status: :created
    else
      render json: { errors: search.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/saved_searches/:id
  def destroy
    search = current_user.saved_searches.find(params[:id])
    
    if search.destroy
      head :no_content
    else
      render json: { error: "Not found" }, status: :not_found
    end
  end
  
  # PUT /api/saved_searches/:id
  def update
    search = current_user.saved_searches.find(params[:id])
    
    if search.update(search_params)
      render json: search_json(search)
    else
      render json: { errors: search.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
  
  def search_params
    params.permit(:name, :alert_frequency)
  end
  
  def criteria_params
    {
      radius: params[:radius]&.to_i || 25,
      lat: params[:lat]&.to_f || 43.7844,
      lng: params[:lng]&.to_f || -88.7879,
      location: params[:location] || '',
      filter: params[:filter] || ''
    }
  end
  
  def search_json(search)
    {
      id: search.id,
      name: search.name,
      criteria: search.criteria_with_defaults,
      alert_frequency: search.alert_frequency,
      last_result_count: search.last_result_count,
      created_at: search.created_at
    }
  end
end
