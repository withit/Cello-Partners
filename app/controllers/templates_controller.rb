class TemplatesController < ApplicationController
  def index 
    @templates = Template.all
  end
end
