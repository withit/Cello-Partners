require 'test_helper'

class PricingGroupTest < ActiveSupport::TestCase
  should_belong_to :pricing_group_name
  should_belong_to :pricing_line
end
