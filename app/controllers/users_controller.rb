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
    @search = User.search
  end
  
  def index
    @search = User.organisation_id_not_null.search(params[:search].merge({:User_ID_greater_than => 1}))
    @users = @search.paginate(:page => params[:page], :per_page => 25)
  end
end
