class Address < ActiveRecord::Base
  set_table_name 'org_addresses'
  
  belongs_to :organsiation, :foreign_key => 'org_id'
  
  def label
    [st_address1, st_address2, st_city] * ' '
  end
end
