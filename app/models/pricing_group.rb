class PricingGroup < ActiveRecord::Base
  belongs_to :pricing_group_name, :foreign_key => 'group_name_id'
  belongs_to :pricing_line, :foreign_key => 'price_id'
end
