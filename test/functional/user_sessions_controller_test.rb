require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  context "show login form" do
    setup{ get :new }
    
    should_respond_with :success
  end
  
  context "logging in with the correct details" do
    setup do
      @user = Factory(:user)
      post :create, :user_session => {:username => @user.username, :password => @user.new_password}
    end
    
    should_respond_with :redirect
    should_redirect_to('home'){root_path}
    should_set_session(:user_id){ @user.id }
  end

  context "logging in with the incorrect details" do
    setup do
      @user = Factory(:user)
      post :create, :user_session => {:username => @user.username, :password => "badpassword"}
    end
    
    should_respond_with :success
    should_render_template :new
    should_set_session(:user_id){ nil }
  end
  
  context "logging out" do
    setup { delete :destroy, {}, authenticated_session}
    
    should_respond_with :redirect
    should_redirect_to('login_path'){login_path}
    should_set_session(:user_id){ nil }
  end

end
