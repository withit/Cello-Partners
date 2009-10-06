class OrdersController < ApplicationController
  def new
    @quote = Quote.find(params[:quote_id])
    @order = @quote.orders.build
    @order.build_address
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
end
