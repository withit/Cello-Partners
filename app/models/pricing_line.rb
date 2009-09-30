class PricingLine < ActiveRecord::Base
  has_many :pricing_groups, :foreign_key => 'price_id'
end
