class Organisation < ActiveRecord::Base
  set_table_name 'shell_organisations'
  has_many :users, :foreign_key => 'Orginisation'
  has_many :quotes
    
end
