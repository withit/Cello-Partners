class TemplatesController < ApplicationController
  def index 
    @templates = Template.all
  end
  
  private
  
  def module_name
    "article_publishing"
  end
  
  def function_name
    "form"
  end
end
