class Action < ActiveRecord::Base
  set_table_name 'shell_options'
  set_primary_key 'ID'
  
  def module
    self.Module
  end
  
  def function
    self.Function
  end
  
  belongs_to :permission, :foreign_key => 'Option_Set_ID'
end
