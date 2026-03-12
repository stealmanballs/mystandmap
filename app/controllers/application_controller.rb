class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Security: Ensure CSRF protection is enabled
  protect_from_forgery with: :exception
  
  helper_method :current_user, :user_signed_in?
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to new_user_session_path, alert: "Please sign in to continue."
    end
  end

  def authenticate_farmer!
    unless current_user&.farmer?
      redirect_to root_path, alert: "Farmer access required."
    end
  end

  def authenticate_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "Admin access required."
    end
  end
  
  # Security: Handle CSRF errors gracefully
  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    redirect_to root_path, alert: "Your session has expired. Please try again."
  end
end
