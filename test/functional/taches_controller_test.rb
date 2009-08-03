require 'test_helper'

class TachesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:taches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tache" do
    assert_difference('Tache.count') do
      post :create, :tache => { }
    end

    assert_redirected_to tache_path(assigns(:tache))
  end

  test "should show tache" do
    get :show, :id => taches(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => taches(:one).to_param
    assert_response :success
  end

  test "should update tache" do
    put :update, :id => taches(:one).to_param, :tache => { }
    assert_redirected_to tache_path(assigns(:tache))
  end

  test "should destroy tache" do
    assert_difference('Tache.count', -1) do
      delete :destroy, :id => taches(:one).to_param
    end

    assert_redirected_to taches_path
  end
end
