require 'test_helper'
require 'digest/md5'
class UserTest < ActiveSupport::TestCase
  should_belong_to :organisation
  should_have_many :privileges
  should_have_many :roles
  
  should "crypt password" do
    user = Factory(:user, :new_password => 'top$ecret')
    assert_equal Digest::MD5.hexdigest('top$ecret'), user.password
  end
end

