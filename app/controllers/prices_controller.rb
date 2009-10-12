class PricesController < ApplicationController
  def new
  end
  
  def create
    Price.import_from_file(params[:price][:data])
    render :text => 'success'
  end
end
