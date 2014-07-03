require 'test_helper'

class App::SiteControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get upload" do
    get :upload
    assert_response :success
  end

  test "should get preview" do
    get :preview
    assert_response :success
  end

end
