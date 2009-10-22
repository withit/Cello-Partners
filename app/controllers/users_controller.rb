class UsersController < ApplicationController

  def edit
    @user = scope.find(params[:id])
  end
  
  def update
    @user = scope.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to_flash_message
    else
      render 'edit'
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.organisation = current_user.organisation if current_user.is_customer?
    if @user.save
      redirect_to [:edit,@user]
    else
      render :new 
    end
  end
  
  def search
    @search = scope.search
  end
  
  def index
    @search = scope.organisation_id_not_null.search(params[:search].merge({:User_ID_greater_than => 1}))
    @users = @search.paginate(:page => params[:page], :per_page => 25)
  end
  
  def destroy
    @user = scope.find(params[:id])
    @user.destroy
    redirect_to search_users_path 
  end
  
  protected
  
  def module_name 
    'shell_user_mgr'
  end
  
  def functions_hash
    returning(super) do |h|
      h["edit"] = "sform"
    end
  end
  
  def security_function
    case action_name
    when 'edit' then 'sform'
    when 'index','search' then 'list'
    when 'destroy' then 'delete'
    when 'new' then 'nrform'
    when 'create' then 'newuser'
    else action_name
    end
  end
  
  protected 
  
  def scope
    current_user.is_customer? ? current_user.organisation.users : User
  end
end
