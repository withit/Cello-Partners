require 'test_helper'

class FlashesControllerTest < ActionController::TestCase
  context "showing the flash" do
    setup{ get :show, {}, authenticated_session}
    should_respond_with :success
  end
end
