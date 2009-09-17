require 'test_helper'

class Admin::ProjetsControllerTest < ActionController::TestCase

  def setup
    Factory :projet, :taches => [Factory(:tache)]
  end

  test "should get show" do
    get :show
    assert_response :success
  end
  
  test "should get edit" do
    get :edit
    assert_response :success
  end
  
  test "should update projet" do
    put :update, :projet => {}
    assert_redirected_to admin_projet_path
  end

end
