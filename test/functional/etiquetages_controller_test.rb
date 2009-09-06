require 'test_helper'

class EtiquetagesControllerTest < ActionController::TestCase
  test "should get index" do
    tags = [1, 2].map{Factory :tag}
    e1, e2, e3 = [0, 1, 0].map{|n| Factory :etiquetage, :tag => tags[n]}
    t1, t2 = tags
    get :index
    assert_response :success
    assert_equal({t1 => [e1, e3], t2 => [e2]}, assigns(:etiquetages))
  end
end
