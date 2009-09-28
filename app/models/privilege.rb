class Privilege < ActiveRecord::Base
  set_table_name :shell_useraccess
  set_primary_key :Access_ID
  belongs_to :user, :foreign_key => 'User_ID'
  belongs_to :role, :foreign_key => 'Group_ID'
end
