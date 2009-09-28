class UserSessionsController < ApplicationController
  skip_before_filter :require_login
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to root_path
    else
      render :new
    end
  end
  
  def destroy
    @user_session = current_user_session
    @user_session.destroy
    flash[:notice] = "You have logged out"
    redirect_to login_path
  end
end
