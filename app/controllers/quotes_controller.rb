class QuotesController < ApplicationController
  before_filter :load_organisation, :require_organisation, :only => [:new, :create, :search, :index]
  
  def new
    @quote = @organisation.quotes.build if @organisation
  end
  
  def create
    @quote =  @organisation.quotes.build(params[:quote])
    @quote.save(false)
    if save_quote? || send_email? || place_order?
      @quote.update_attribute(:status, 1)
      @quote.deliver_as_email if send_email?
      place_order? ? redirect_to(new_quote_order_path(@quote)) : redirect_to_flash_message
    else
      @quote = @quote.clones.build
      @quote.valid?
      render 'new'
    end
  end
  
  def search
    @search = Quote.search
  end
  
  def index
    @search = @organisation.orders_and_quotes.search(params[:search])
    @quotes = params[:format] != 'xls' ? @search.paginate(:page => params[:page], :per_page => 25) : @search.all if params[:search]
  end
  
  def show
    @quote = Quote.find(params[:id])
  end
  
  private
  
  def functions_hash
    returning(super) do |h|
      h["new"] = "nrform"
      h["create"] = "nrform"
    end
  end
end
