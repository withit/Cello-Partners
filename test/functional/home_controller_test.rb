require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  context "on get to index when authenticated" do
    setup { get :index, {}, authenticated_session }
    should_respond_with :success
  end
  
  context "on get to index when not authenticated" do
    setup { get :index, {}}
    should_respond_with :redirect
    should_redirect_to('login'){login_path}
  end
end
