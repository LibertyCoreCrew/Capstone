class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  #helper_method :user_signed_in?, :current_user
  
  
  protected
  
  def authenticate_user
    if current_user.blank? {
      puts "authenticated"
      cookies.delete(:user_id)
      redirect_to root_url
      return false
    }
    end
    #cookies.delete(:user_id) && redirect_to(root_url) if current_user.blank?
    return true
  end
  
  def current_user
    @current_user ||= User.find_by(name: cookies.signed[:user_id])
  end
  
  def user_signed_in?
    current_user.present?
  end
    
end
