# frozen_string_literal: true

class User::DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @favorites = current_user.favorites.includes(:stand).order(created_at: :desc).limit(10)
    @saved_searches = current_user.saved_searches.order(created_at: :desc).limit(10)
  end
end
