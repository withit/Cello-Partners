require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase

  context "edititng a profile" do
    setup do
      @user = Factory(:user)
      get :edit, {}, authenticated_session(@user)
    end
    
    should_respond_with :success
    should_render_template :edit
    should_assign_to(:profile){@user}
  end
  
  context "updating a profile" do
    setup do
      @user = Factory(:user)
      put :update, {:profile => {}}, authenticated_session(@user)
    end
    
    should_respond_with :redirect
    should_redirect_to('flash'){flash_path}
  end
end
