class Grant < ActiveRecord::Base
  set_table_name :shell_permissions
  set_primary_key 'ID'
  
  belongs_to :role, :foreign_key => 'User_Group_ID'
  belongs_to :permission, :foreign_key => 'Option_set_ID'
  
  def permission_id= new_permission_id
    self.Option_set_ID = new_permission_id
  end
end
