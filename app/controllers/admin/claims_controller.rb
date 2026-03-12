# frozen_string_literal: true

class Admin::ClaimsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @claims = Claim.includes(:user, :stand).order(created_at: :desc)
  end
  
  def approve
    @claim = Claim.find(params[:id])
    @claim.approved!
    @claim.stand.update(claimed: true)
    redirect_to admin_claims_path, notice: "Claim approved!"
  end
  
  def reject
    @claim = Claim.find(params[:id])
    @claim.rejected!
    redirect_to admin_claims_path, notice: "Claim rejected."
  end
end
