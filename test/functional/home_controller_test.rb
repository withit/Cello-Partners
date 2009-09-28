require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  context "when logged in" do
    setup{ login }
    context "on get to index" do
      setup { get :index }
      should_respond_with :success
    end
  end
  
  def login
    get :index
    UserSession.controller = @controller
    user = Factory(:user)
    UserSession.new(:username => user.username, :password => user.new_password).save
  end
end
