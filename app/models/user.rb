class User < ActiveRecord::Base
  set_table_name "shell_users"
  set_primary_key 'User_ID'
  
  def self.find_by_username username
    first(:conditions => {:Username => username})
  end
  
  def password
    self.Password
  end
end
