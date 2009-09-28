class Role < ActiveRecord::Base
  set_table_name :shell_groups
  set_primary_key :Group_ID
  
  has_many :grants, :foreign_key => 'User_Group_ID'
  has_many :permissions, :through => :grants
  has_many :privileges, :foreign_key => "Group_ID"
  has_many :users, :through => :privileges
end
