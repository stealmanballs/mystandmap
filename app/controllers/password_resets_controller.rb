# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :find_user_by_email, only: [:create]
  before_action :find_user_by_token, only: [:edit, :update]
  before_action :check_token_expiration, only: [:edit, :update]
  
  def new
  end
  
  def create
    if @user
      token = @user.generate_password_reset_token
      UserMailer.password_reset(@user, token).deliver_now
    end
    
    # Always show success to prevent email enumeration
    redirect_to new_session_path, notice: "If an account exists with that email, you will receive password reset instructions shortly."
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      @user.clear_password_reset_token!
      redirect_to new_session_path, notice: "Password has been reset. Please sign in with your new password."
    else
      render :edit
    end
  end
  
  private
  
  def find_user_by_email
    @user = User.find_by(email: params[:email])
  end
  
  def find_user_by_token
    @user = User.find_by(reset_password_token: params[:id])
    unless @user
      redirect_to new_password_reset_path, alert: "Invalid or expired reset token."
    end
  end
  
  def check_token_expiration
    unless @user.password_reset_valid?
      redirect_to new_password_reset_path, alert: "Password reset token has expired. Please request a new one."
    end
  end
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
