require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should_belong_to :organisation
  should_have_many :privileges
  should_have_many :roles
end
