class FlashesController < ApplicationController
  def show
  end
  
  private
  
  def authorize_for_action *args
    true # anyone can see this
  end
end
