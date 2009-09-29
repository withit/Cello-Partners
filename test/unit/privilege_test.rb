require 'test_helper'

class PrivilegeTest < ActiveSupport::TestCase
  should_belong_to :user
  should_belong_to :role
end
