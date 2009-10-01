class QuotesController < ApplicationController
  before_filter :load_organisation, :require_organisation, :only => [:new, :create, :search, :index]
  
  def new
    @quote = @organisation.quotes.build if @organisation
  end
  
  def create
    @quote =  @organisation.quotes.build(params[:quote])
    render 'new'
  end
  
  def search
    @search = Quote.search
  end
  
  def index
    @search = @organisation.quotes.search(params[:search])
    @quotes = @search.paginate(:page => params[:page], :per_page => 25)
  end
  
  def show
    @quote = Quote.find(params[:id])
  end
  
  protected
  
  def require_organisation
    render 'organisations/select' unless @organisation
  end
  
  def load_organisation
    @organisation = Organisation.find(params[:organisation_id]) if params[:organisation_id]
  end
end
