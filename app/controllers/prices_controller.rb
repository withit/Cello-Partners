class PricesController < ApplicationController
  include ValueLists
  def new
  end
  
  def upload
    Price.import_from_file(params[:price][:data])
    render :text => 'success'
  end
  
  private
  
  def module_name
    ["new","upload"].include?(action_name) ? 'load_pricing_data' : 'pricing_data'
  end
  
  def functions_hash
    returning(super) do |h|
      h["new"] = "form"
    end
  end
end
