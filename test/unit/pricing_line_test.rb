require 'test_helper'

class PricingLineTest < ActiveSupport::TestCase
  should_have_many :pricing_groups
end
