require 'test_helper'

class EtiquetagesControllerTest < ActionController::TestCase
  test "should get index" do
    Factory(:etiquetage)
    get :index
    assert_response :success
    assert_not_nil assigns(:etiquetages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create etiquetage" do
    assert_difference('Etiquetage.count') do
      post :create, :etiquetage => {:tag => Factory(:tag), :tache => Factory(:tache)}
    end

    assert_redirected_to etiquetage_path(assigns(:etiquetage))
  end

  test "should show etiquetage" do
    get :show, :id => Factory(:etiquetage)
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => Factory(:etiquetage)
    assert_response :success
  end

  test "should update etiquetage" do
    put :update, :id => Factory(:etiquetage), :etiquetage => { }
    assert_redirected_to etiquetage_path(assigns(:etiquetage))
  end

  test "should destroy etiquetage" do
    etiquetage = Factory(:etiquetage)
    assert_difference('Etiquetage.count', -1) do
      delete :destroy, :id => etiquetage
    end

    assert_redirected_to etiquetages_path
  end
end
