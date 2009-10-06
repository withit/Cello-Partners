class Permission < ActiveRecord::Base
  set_table_name :shell_option_sets
  
  has_many :grants, :foreign_key => 'Option_set_ID'
  has_many :roles, :through => :grants
  
  #has_many :children, :foreign_key => 'parent', :order => 'sort'
  # has_many :actions
  belongs_to :action, :foreign_key => 'default_first_option'
  
  def module
    self.Module
  end
  
  def function
    self.Function
  end
  def url
    case 
    when self.module == 'shell_editmyself'
      lambda{edit_profile_path}
    when self.module == 'shell_user_mgr' && self.function == 'nrform'
      lambda{new_user_path}
    when self.module == 'shell_user_mgr' && self.function == 'sform'
      lambda{search_users_path}
    when self.module == 'quotes' && self.function == 'nrform'
      lambda{new_quote_path}
    when self.module == 'quotes' && self.function == 'sform'
      lambda{search_quotes_path}
    when self.module == 'shell_group_mgr' && self.function == 'nrform'
      lambda{new_role_path}
    when self.module == 'shell_group_mgr' && self.function == 'edit'
      lambda{roles_path}
    else 
      lambda{'#'}
    end
  end
end
