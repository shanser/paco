require 'test_helper'

class Admin::TachesControllerTest < ActionController::TestCase
  attr_reader :projet

  def setup
    @projet = Factory :projet
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tache" do
    assert_difference('projet.taches.count') do
      post :create, :tache => {:description => 'tache' }
    end

    assert_redirected_to admin_projet_tache_path(assigns(:tache))
  end

  test "should show tache" do
    get :show, :id => Factory(:tache)
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => Factory(:tache)
    assert_response :success
  end

  test "should update tache" do
    put :update, :id => Factory(:tache), :tache => { }
    assert_redirected_to admin_projet_tache_path(assigns(:tache))
  end

  test "should destroy tache" do
    tache = Factory(:tache)
    assert_difference('Tache.count', -1) do
      delete :destroy, :id => tache
    end

    assert_redirected_to admin_projet_path
  end
  
end
