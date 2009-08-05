require 'test_helper'

class TachesControllerTest < ActionController::TestCase
  test "should get index" do
    demarrage = date_reference
    [2, 4].map{|i| Factory(:tache, :statut => 'OK', :date_sortie => demarrage + i.days)}
    tache_non_finie = Factory(:tache)
    get :index
    assert_response :success
    assert_not_nil assigns(:taches)
    assert_equal "Paco prédit que le projet se finira le January 07, 2001 00:00", assigns(:prediction_date_fin)
  end

  test "sait gérer le cas où il n'y a pas assez de tâches terminées pour prédire la fin du projet" do
    get :index
    assert_response :success
    assert_equal 'Paco ne sait pas encore prédire la date de fin du projet', assigns(:prediction_date_fin)
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
    get :show, :id => Factory(:tache)
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => Factory(:tache)
    assert_response :success
  end

  test "should update tache" do
    put :update, :id => Factory(:tache), :tache => { }
    assert_redirected_to tache_path(assigns(:tache))
  end

  test "should destroy tache" do
    tache = Factory(:tache)
    assert_difference('Tache.count', -1) do
      delete :destroy, :id => tache
    end

    assert_redirected_to taches_path
  end
end
