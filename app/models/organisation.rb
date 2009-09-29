class Organisation < ActiveRecord::Base
  set_table_name 'shell_organisations'
  has_many :users, :foreign_key => 'Organisation'
  has_many :quotes, :foreign_key => 'org_id'
    
end
