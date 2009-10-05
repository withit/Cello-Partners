class OrdersController < ApplicationController
  def new
    @quote = Quote.find(params[:quote_id])
    @order = @quote.orders.build
    @order.build_address
  end
end
