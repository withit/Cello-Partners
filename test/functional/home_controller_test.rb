require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  context "on get to index" do
    setup { get :index, {}, :user_id => Factory(:user).id.to_s }
    should_respond_with :success
  end
end
