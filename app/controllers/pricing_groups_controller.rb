class PricingGroupsController < ApplicationController
  include ValueLists
  
  def load_all_objects
    @current_objects =  current_model.all(:joins => :pricing_group_name, :order => "pricing_group_names.name, sort")
    instance_variable_set "@#{plural_instance_variable_name}", @current_objects
  end
end
