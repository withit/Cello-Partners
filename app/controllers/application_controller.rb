# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :activeate_user_session
  
  before_filter :require_login
  protected 
  def activeate_user_session
    UserSession.controller = self
  end
  
  def require_login
    unless current_user
      flash[:warning] = "Not authorized"
      redirect_to login_path
    end
  end
  
  def current_user_session
    UserSession.find
  end
  
  def current_user
    current_user_session && current_user_session.user
  end
  
  helper_method :current_user
end
