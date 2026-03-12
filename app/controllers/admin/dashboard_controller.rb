# frozen_string_literal: true

class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @total_stands = Stand.count
    @claimed_stands = Stand.where(claimed: true).count
    @pending_claims = Claim.where(status: 'pending').count
    @recent_stands = Stand.order(created_at: :desc).limit(10)
    @recent_claims = Claim.order(created_at: :desc).limit(10)
  end
end
