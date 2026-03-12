# frozen_string_literal: true

class Api::FavoritesController < ApplicationController
  before_action :authenticate_user!
  
  # GET /api/favorites
  def index
    favorites = current_user.favorites.includes(:stand).order(created_at: :desc)
    render json: favorites.map { |f| favorite_json(f) }
  end
  
  # POST /api/favorites
  def create
    stand = Stand.find(params[:stand_id])
    
    if current_user.favorites.exists?(stand_id: stand.id)
      render json: { error: "Already favorited" }, status: :unprocessable_entity
      return
    end
    
    favorite = current_user.favorites.build(stand: stand)
    
    if favorite.save
      render json: favorite_json(favorite), status: :created
    else
      render json: { errors: favorite.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/favorites/:stand_id
  def destroy
    favorite = current_user.favorites.find_by(stand_id: params[:stand_id])
    
    if favorite&.destroy
      head :no_content
    else
      render json: { error: "Not favorited" }, status: :not_found
    end
  end
  
  # GET /api/favorites/check?stand_id=1
  def check
    is_favorited = current_user.favorites.exists?(stand_id: params[:stand_id])
    render json: { favorited: is_favorited }
  end
  
  private
  
  def favorite_json(favorite)
    stand = favorite.stand
    {
      id: favorite.id,
      stand_id: stand.id,
      stand_name: stand.name,
      stand_city: stand.city,
      stand_state: stand.state,
      stand_type: stand.stand_type,
      products_text: stand.products_text,
      created_at: favorite.created_at
    }
  end
end
