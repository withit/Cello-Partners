class QuotesController < ApplicationController
  before_filter :load_organisation
  
  def new
    @quote = @organisation.quotes.build if @organisation
  end
  
  def create
    @quote =  @organisation.quotes.build(params[:quote])
    render 'new'
  end
  
  protected
    
  def load_organisation
    @organisation = Organisation.find(params[:organisation_id]) if params[:organisation_id]
  end
end
