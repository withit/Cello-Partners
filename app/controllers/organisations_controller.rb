class OrganisationsController < ApplicationController
  def index
    @organisations = Organisation.all(:order => 'name')
  end
  
  def new
    @organisation = Organisation.new
  end
  
  def edit
    @organisation = Organisation.find(params[:id])
  end
  
  def show
    @organisation = current_user.organisation
  end
  
  def create
    @organisation = Organisation.new(params[:organisation])
    if @organisation.save
      redirect_to organisations_path
    else
      render "new"
    end
  end
  
  def update
    @organisation = Organisation.find(params[:id])
    if @organisation.update_attributes(params[:organisation])
      redirect_to organisations_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @organisation.find(params[:id])
    @organisation.destroy
    redirect_to organsiations_path
  end
end
