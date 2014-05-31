require 'test_helper'

class SiteImagesControllerTest < ActionController::TestCase
  setup do
    @site_image = site_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:site_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site_image" do
    assert_difference('SiteImage.count') do
      post :create, site_image: { description: @site_image.description, file: @site_image.file, site_page_id: @site_image.site_page_id, title: @site_image.title }
    end

    assert_redirected_to site_image_path(assigns(:site_image))
  end

  test "should show site_image" do
    get :show, id: @site_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @site_image
    assert_response :success
  end

  test "should update site_image" do
    patch :update, id: @site_image, site_image: { description: @site_image.description, file: @site_image.file, site_page_id: @site_image.site_page_id, title: @site_image.title }
    assert_redirected_to site_image_path(assigns(:site_image))
  end

  test "should destroy site_image" do
    assert_difference('SiteImage.count', -1) do
      delete :destroy, id: @site_image
    end

    assert_redirected_to site_images_path
  end
end
