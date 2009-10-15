class PasswordResetsController < ApplicationController
  skip_before_filter :require_login, :except => :destroy
  before_filter :require_not_logged_in
  
  def new
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.reset_password!
      flash[:notice] = "Your password has been reset and your new password emailed to you"
      redirect_to login_path
    else
      flash.now[:error] = "There is no user with that email address"
      render 'new'
    end
  end
  
end
