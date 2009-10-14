class RepsController < ApplicationController
  def show
    @rep = current_user.organisation.rep
  end
  
  private
  
  def module_name 
    "contactcello"
  end
  
  def function_name
    "list"
  end
end
