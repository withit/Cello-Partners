class PricingGroupName < ActiveRecord::Base
  has_many :organisations, :foreign_key => 'pricing_group_id'
  has_many :pricing_groups, :foreign_key => 'group_name_id'
end
