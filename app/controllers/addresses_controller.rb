class AddressesController < ApplicationController
  before_filter :set_headings
  before_filter :load_organisation, :require_organisation, :only => :index

  
  def new
    @address = Address.new
  end
  
  def index
    @addresses = @organisation.addresses
  end
  
  def edit
    @address = Address.find(params[:id])
  end
  
  def update
    @address = Address.find(params[:id])
    if @address.update_attributes(params[:address])
      redirect_to organisation_addresses_path(@address.organisation)
    else
      render 'edit'
    end
  end
  
  def create
    @address = Address.new(params[:address])
    if @address.save
      redirect_to organisation_addresses_path(@address.organisation)
    else
      render 'new'
    end
  end
  
  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    redirect_to organisation_addresses_path(@address.organisation)
  end
  
  private
  
  def module_name
    'org_addresses'
  end
  
  def set_headings
    @heading = "Addresses"
    @subheading = "Listing Addresses"
  end
end
