class OrdersController < ApplicationController
  def new
    @quote = Quote.find(params[:quote_id])
    @order = @quote.orders.build
    @order.build_address
    @order.email = current_user.email
    @order.authorizer_name = current_user.full_name
    @order.required_date = Date.today + Setting.leadtime.to_i
  end
  
  def create
    @quote = Quote.find(params[:quote_id])
    @order = @quote.orders.build(params[:order])
    if @order.save
      redirect_to_flash_message
    else
      render 'new'
    end
  end
  
  def show
    @order = Order.find(params[:id])
  end
  
  protected
  
  private
  
  def functions_hash
    returning(super) do |h|
      h["new"] = "nrform"
      h["create"] = "nrform"
    end
  end
  
  def module_name
    'quotes'
  end
end
