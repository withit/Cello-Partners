class QuotesController < ApplicationController
  before_filter :load_organisation, :require_organisation, :only => [:new, :create, :search, :index]
  
  def new
    @quote = @organisation.quotes.build if @organisation
  end
  
  def create
    @quote =  @organisation.quotes.build(params[:quote])
    @quote.save(false)
    if save_quote? || send_email?
      @quote.update_attribute(:status, 1)
      @quote.deliver_as_email if send_email?
      redirect_to_flash_message
    else
      @quote = @quote.clones.build
      render 'new'
    end
  end
  
  def search
    @search = Quote.search
  end
  
  def index
    @search = @organisation.quotes.search(params[:search])
    @quotes = params[:format] != 'xls' ? @search.paginate(:page => params[:page], :per_page => 25) : @search.all
  end
  
  def show
    @quote = Quote.find(params[:id])
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
