# frozen_string_literal: true

class ClaimsController < ApplicationController
  before_action :authenticate_user!, except: [:new]
  
  def new
    @stand = Stand.friendly.find(params[:stand_id])
    if @stand.claimed?
      redirect_to @stand, alert: "This stand has already been claimed."
    end
    @claim = Claim.new
  end
  
  def create
    @stand = Stand.friendly.find(params[:stand_id])
    
    if @stand.claimed?
      redirect_to @stand, alert: "This stand has already been claimed."
      return
    end
    
    @claim = @stand.claims.new(user: current_user, notes: params[:claim][:notes])
    
    if @claim.save
      redirect_to @stand, notice: "Claim submitted! We'll review it shortly."
    else
      flash.now[:alert] = @claim.errors.full_messages.join(", ")
      render :new
    end
  end
end
