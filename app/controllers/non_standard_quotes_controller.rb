class NonStandardQuotesController < ApplicationController
  before_filter :load_organisation, :require_organisation, :only => [:new, :create, :search, :index]
  def new
    @quote = @organisation.quotes.build do |quote|
      quote.notes = "This is a non standard price and is subject to reconfirmation at the time of ordering"
    end
  end
  
  def create
    @quote =  @organisation.quotes.build(params[:quote])
    @quote.standard = false
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
  
  private
  
  def module_name
    "nonstandardquote"
  end
  
  def function_name
    "nrform"
  end
end
