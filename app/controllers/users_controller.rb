class UsersController < ApplicationController
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = render_to_string(:layout => false)
      redirect_to flash_path
    else
      render 'edit'
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to [:edit,@user]
    else
      render :new 
    end
  end
  
  def search
  end
end
