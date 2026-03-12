# frozen_string_literal: true

class Farmer::DashboardController < ApplicationController
  before_action :authenticate_farmer!
  
  def show
    @user = current_user
    @stands = Stand.joins(:claims).where(claims: { user_id: @user.id, status: 'approved' })
    @pending_claims = Claim.where(stand_id: @stands.select(:id), status: 'pending') if @user.admin?
  end
end
