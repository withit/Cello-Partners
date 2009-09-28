require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context "showing new form" do
    setup { get :new, {}, authenticated_session}
    
    should_respond_with :success
    should_render_template :new
    should_assign_to(:user, :class => User)
    
  end
  
  context "logged in as existing user" do
    setup {@current_user = Factory(:user)} #seperate this out to isolate the effect on the number of users
    context "creating a new user" do
      setup { post :create, {:user => Factory.attributes_for(:user)}, authenticated_session(@current_user)}
    
      should_respond_with :redirect
      should_redirect_to('edit'){[:edit,assigns(:user)]}
      should_change("User.count", :by => 1){User.count}
    end
  end
  
  
  context "editing an existing user" do
    setup do
      @user = Factory(:user)
      get :edit, {:id => @user.id}, authenticated_session
    end
    
    should_respond_with :success
    should_render_template :edit
    should_assign_to(:user){@user}
    
  end
  
  context "updating an existing user" do
    setup do
      @user = Factory(:user)
      put :update, {:id => @user.id, :user => {}}, authenticated_session
    end
    
    should_respond_with :redirect
    should_redirect_to('flash'){flash_path}
    should_assign_to(:user){@user}
    
  end
  
  context "showing search form" do
    setup{ get :search, {}, authenticated_session}
    
    should_respond_with :success
    should_render_template :search
  end
  
  context "showing search results" do
    setup{ get :index, {:search => {}}, authenticated_session}
    
    should_assign_to(:users)
    should_render_template :index
  end
  
end
