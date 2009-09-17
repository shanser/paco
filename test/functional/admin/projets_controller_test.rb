require 'test_helper'

class Admin::ProjetsControllerTest < ActionController::TestCase

  test "should get show" do
    Factory :projet, :taches => [Factory(:tache)]
    get :show
    assert_response :success
  end

end
