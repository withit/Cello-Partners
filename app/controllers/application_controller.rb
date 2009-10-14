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
  
  def redirect_to_flash_message
    flash[:notice] = render_to_string(:layout => false)
    redirect_to flash_path
  end
  
  protected
  
  def require_organisation
    render 'organisations/select' unless @organisation
  end
  
  def load_organisation
    if current_user.is_customer?
      @organisation = current_user.organisation
    else
      @organisation = Organisation.find(params[:organisation_id]) if params[:organisation_id]
    end
  end
  
  def save_quote?
    params[:commit] == 'Create Quote'
  end
  
  def send_email?
    params[:commit] == "Send Email"
  end
  
  def place_order?
    params[:commit] == "Place Order"
  end
end
