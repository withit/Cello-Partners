class RolesController < ApplicationController
  def new
    @role = Role.new
  end
  
  def create
    @role = Role.new(params[:role])
    if @role.save
      redirect_to_flash_message
    else
      render 'new'
    end
  end
  
  def index
    @roles = Role.all
  end
  
  def edit
    @role = Role.find(params[:id])
  end
end
