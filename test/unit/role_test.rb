require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  should_have_many :grants
  should_have_many :permissions
  should_have_many :privileges
  should_have_many :users
end
