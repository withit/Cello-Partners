class Address < ActiveRecord::Base
  set_table_name 'org_addresses'
  
  belongs_to :organisation, :foreign_key => 'org_id'
  has_many :orders, :class_name => 'Quote'
  def label
    [st_address1, st_address2, st_city] * ' '
  end

end
