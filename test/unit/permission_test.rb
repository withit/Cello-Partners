require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  should_have_many :grants
  should_have_many :roles
  should_belong_to :action
end
