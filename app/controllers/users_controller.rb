class UsersController < ApplicationController
  before_filter :require_access
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
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
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_search_path 
  end
  
  protected
  
  def require_access
    
    #render :text => "Not authorized" unless current_user.has_access_to? security_module, security_function
  end
  
  def security_module 
    'shell_user_mgr'
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
end
