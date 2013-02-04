require 'test_helper'

class GemInfosControllerTest < ActionController::TestCase
  setup do
    @gem_info = gem_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gem_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gem_info" do
    assert_difference('GemInfo.count') do
      post :create, gem_info: { gem_server: @gem_info.gem_server, md5sum: @gem_info.md5sum, name: @gem_info.name, source: @gem_info.source, version: @gem_info.version }
    end

    assert_redirected_to gem_info_path(assigns(:gem_info))
  end

  test "should show gem_info" do
    get :show, id: @gem_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gem_info
    assert_response :success
  end

  test "should update gem_info" do
    put :update, id: @gem_info, gem_info: { gem_server: @gem_info.gem_server, md5sum: @gem_info.md5sum, name: @gem_info.name, source: @gem_info.source, version: @gem_info.version }
    assert_redirected_to gem_info_path(assigns(:gem_info))
  end

  test "should destroy gem_info" do
    assert_difference('GemInfo.count', -1) do
      delete :destroy, id: @gem_info
    end

    assert_redirected_to gem_infos_path
  end
end
