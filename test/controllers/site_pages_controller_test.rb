require 'test_helper'

class SitePagesControllerTest < ActionController::TestCase
  setup do
    @site_page = site_pages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:site_pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site_page" do
    assert_difference('SitePage.count') do
      post :create, site_page: { short_title: @site_page.short_title, site_id: @site_page.site_id, template_page_id: @site_page.template_page_id, title: @site_page.title, user_id: @site_page.user_id }
    end

    assert_redirected_to site_page_path(assigns(:site_page))
  end

  test "should show site_page" do
    get :show, id: @site_page
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @site_page
    assert_response :success
  end

  test "should update site_page" do
    patch :update, id: @site_page, site_page: { short_title: @site_page.short_title, site_id: @site_page.site_id, template_page_id: @site_page.template_page_id, title: @site_page.title, user_id: @site_page.user_id }
    assert_redirected_to site_page_path(assigns(:site_page))
  end

  test "should destroy site_page" do
    assert_difference('SitePage.count', -1) do
      delete :destroy, id: @site_page
    end

    assert_redirected_to site_pages_path
  end
end
