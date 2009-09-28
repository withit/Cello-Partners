class ProfilesController < ApplicationController
  def edit
    @profile = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:profile])
      flash[:notice] = render_to_string(:layout => false)
      redirect_to flash_path
    else
      render 'edit'
    end
  end
end
