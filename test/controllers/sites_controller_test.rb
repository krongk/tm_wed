require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  setup do
    @site = sites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site" do
    assert_difference('Site.count') do
      post :create, site: { description: @site.description, domain: @site.domain, is_comment_show: @site.is_comment_show, is_publiched: @site.is_publiched, note: @site.note, short_title: @site.short_title, status: @site.status, template_id: @site.template_id, title: @site.title, updated_by: @site.updated_by, user_id: @site.user_id }
    end

    assert_redirected_to site_path(assigns(:site))
  end

  test "should show site" do
    get :show, id: @site
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @site
    assert_response :success
  end

  test "should update site" do
    patch :update, id: @site, site: { description: @site.description, domain: @site.domain, is_comment_show: @site.is_comment_show, is_publiched: @site.is_publiched, note: @site.note, short_title: @site.short_title, status: @site.status, template_id: @site.template_id, title: @site.title, updated_by: @site.updated_by, user_id: @site.user_id }
    assert_redirected_to site_path(assigns(:site))
  end

  test "should destroy site" do
    assert_difference('Site.count', -1) do
      delete :destroy, id: @site
    end

    assert_redirected_to sites_path
  end
end
