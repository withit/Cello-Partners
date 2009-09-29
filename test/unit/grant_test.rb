require 'test_helper'

class GrantTest < ActiveSupport::TestCase
  should_belong_to :role
  should_belong_to :permission
end
