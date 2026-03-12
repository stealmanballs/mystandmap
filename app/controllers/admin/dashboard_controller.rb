# frozen_string_literal: true

class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    # Stand counts
    @total_stands = Stand.count
    @claimed_stands = Stand.where(claimed: true).count
    @verified_stands = Stand.where(verified: true).count
    
    # Claim counts
    @pending_claims = Claim.where(status: 'pending').count
    @approved_claims = Claim.where(status: 'approved').count
    @rejected_claims = Claim.where(status: 'rejected').count
    
    # User counts
    @total_users = User.count
    @farmers = User.where(role: 'farmer').count
    @admins = User.where(role: 'admin').count
    
    # Recent data
    @recent_stands = Stand.order(created_at: :desc).limit(10)
    @recent_claims = Claim.includes(:user, :stand).order(created_at: :desc).limit(10)
    @recent_signups = User.order(created_at: :desc).limit(10)
    
    # Import batches
    @recent_imports = ImportBatch.order(created_at: :desc).limit(5)
    
    # Stand type breakdown
    @stands_by_type = Stand.group(:stand_type).count
    
    # Top cities
    @top_cities = Stand.group(:city).order('COUNT(*) DESC').limit(10).count
  end
end
