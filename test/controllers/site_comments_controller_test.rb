require 'test_helper'

class SiteCommentsControllerTest < ActionController::TestCase
  setup do
    @site_comment = site_comments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:site_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site_comment" do
    assert_difference('SiteComment.count') do
      post :create, site_comment: { address: @site_comment.address, birth: @site_comment.birth, content2: @site_comment.content2, content3: @site_comment.content3, content: @site_comment.content, email: @site_comment.email, gender: @site_comment.gender, hobby: @site_comment.hobby, mobile_phone: @site_comment.mobile_phone, name: @site_comment.name, note: @site_comment.note, qq: @site_comment.qq, site_id: @site_comment.site_id, status: @site_comment.status, tel_phone: @site_comment.tel_phone, template_page_id: @site_comment.template_page_id, updated_by: @site_comment.updated_by, weibo: @site_comment.weibo, weixin: @site_comment.weixin }
    end

    assert_redirected_to site_comment_path(assigns(:site_comment))
  end

  test "should show site_comment" do
    get :show, id: @site_comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @site_comment
    assert_response :success
  end

  test "should update site_comment" do
    patch :update, id: @site_comment, site_comment: { address: @site_comment.address, birth: @site_comment.birth, content2: @site_comment.content2, content3: @site_comment.content3, content: @site_comment.content, email: @site_comment.email, gender: @site_comment.gender, hobby: @site_comment.hobby, mobile_phone: @site_comment.mobile_phone, name: @site_comment.name, note: @site_comment.note, qq: @site_comment.qq, site_id: @site_comment.site_id, status: @site_comment.status, tel_phone: @site_comment.tel_phone, template_page_id: @site_comment.template_page_id, updated_by: @site_comment.updated_by, weibo: @site_comment.weibo, weixin: @site_comment.weixin }
    assert_redirected_to site_comment_path(assigns(:site_comment))
  end

  test "should destroy site_comment" do
    assert_difference('SiteComment.count', -1) do
      delete :destroy, id: @site_comment
    end

    assert_redirected_to site_comments_path
  end
end
