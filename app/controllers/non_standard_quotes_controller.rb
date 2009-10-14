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
  
  protected
  
  def require_organisation
    render 'organisations/select' unless @organisation
  end
  
  def load_organisation
    if current_user.is_customer?
      @organisation = current_user.organisation
    else
      @organisation = Organisation.find(params[:organisation_id]) if params[:organisation_id]
    end
  end
  
  def save_quote?
    params[:commit] == 'Create Quote'
  end
  
  def send_email?
    params[:commit] == "Send Email"
  end
  
  def place_order?
    params[:commit] == "Place Order"
  end
end
