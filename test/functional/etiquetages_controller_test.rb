require 'test_helper'

class EtiquetagesControllerTest < ActionController::TestCase
  test "should get index" do
    Factory :projet
    t1, t2 = Factory(:tag), Factory(:tag)
    e1, e2, e3 = [t1, t2, t1].map{|tag| Factory :etiquetage, :tag => tag}
    get :index
    assert_response :success
    assert_equal({t1 => [e1, e3], t2 => [e2]}, assigns(:etiquetages))
  end
end
