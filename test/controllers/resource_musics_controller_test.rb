require 'test_helper'

class ResourceMusicsControllerTest < ActionController::TestCase
  setup do
    @resource_music = resource_musics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resource_musics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resource_music" do
    assert_difference('ResourceMusic.count') do
      post :create, resource_music: { name: @resource_music.name, url: @resource_music.url, user_id: @resource_music.user_id }
    end

    assert_redirected_to resource_music_path(assigns(:resource_music))
  end

  test "should show resource_music" do
    get :show, id: @resource_music
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @resource_music
    assert_response :success
  end

  test "should update resource_music" do
    patch :update, id: @resource_music, resource_music: { name: @resource_music.name, url: @resource_music.url, user_id: @resource_music.user_id }
    assert_redirected_to resource_music_path(assigns(:resource_music))
  end

  test "should destroy resource_music" do
    assert_difference('ResourceMusic.count', -1) do
      delete :destroy, id: @resource_music
    end

    assert_redirected_to resource_musics_path
  end
end
