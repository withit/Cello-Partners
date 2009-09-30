require 'test_helper'

class PricingGroupNameTest < ActiveSupport::TestCase
  should_have_many :organisations
  should_have_many :pricing_groups
end
