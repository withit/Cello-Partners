class Permission < ActiveRecord::Base
  set_table_name :shell_option_sets
  
  has_many :grants, :foreign_key => 'Option_set_ID'
  has_many :roles, :through => :grants
  
  #has_many :children, :foreign_key => 'parent', :order => 'sort'
  # has_many :actions
  belongs_to :action, :foreign_key => 'default_first_option'
end
