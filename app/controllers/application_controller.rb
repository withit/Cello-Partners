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
    deny_access unless current_user && authorize_for_action
  end
  
  def deny_access
    flash[:warning] = "Not authorized"
    redirect_to login_path
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
  
  def module_name
    controller_name
  end
  
  def function_name
    functions_hash[action_name]
  end
  
  def functions_hash
    returning(Hash.new{|h,k| k}) do |h|
      h["index"] = "list"
      h["destroy"] = "delete"
      h["create"] = ["insert","newuser","publish"]
      h["show"] = "detail"
      h["new"] = ["new", "form","nrform"]
      h["edit"] = ["edit", "editPerm","editCat","editform",'EditMyself']
      h["update"] = ["update",'UpdateMyself']
      h["search"] = ['sform']
    end
  end
  
  def authorize_for_action
    raise([module_name, function_name].inspect) unless current_user.can_access?(module_name, function_name)
    true
  end

  def require_not_logged_in
    redirect_to root_path if current_user
  end

end
