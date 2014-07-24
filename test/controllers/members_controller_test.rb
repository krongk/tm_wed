require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  test "should get send_token" do
    get :send_token
    assert_response :success
  end

end
