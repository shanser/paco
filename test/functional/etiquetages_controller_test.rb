require 'test_helper'

class EtiquetagesControllerTest < ActionController::TestCase
  test "should get index" do
    Factory(:etiquetage)
    get :index
    assert_response :success
    assert_not_nil assigns(:etiquetages)
  end
end
