# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      session[:user_id] = user.id
      redirect_to after_sign_in_path_for(user), notice: "Welcome back!"
    else
      flash.now[:alert] = "Invalid email or password."
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Signed out successfully."
  end
  
  private
  
  def after_sign_in_path_for(user)
    if user.admin?
      admin_dashboard_path
    elsif user.farmer?
      farmer_dashboard_path
    else
      root_path
    end
  end
end
