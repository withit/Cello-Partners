class ProfilesController < ApplicationController
  def edit
    @profile = current_user
  end
  
  def update
    @profile = current_user
    if @profile.update_attributes(params[:profile])
      flash[:notice] = render_to_string(:layout => false)
      redirect_to flash_path
    else
      render 'edit'
    end
  end
end
