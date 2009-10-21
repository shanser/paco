require 'test_helper'

class NuagePointsTest < ActiveSupport::TestCase
  test "sait revoyer un sous-nuage" do
    np = NuagePoints.new [1, 2, 3], [4, 5, 6]
    sous_nuage = np.sous_nuage_points 2
    assert_equal [1, 2], sous_nuage.xs
    assert_equal [4, 5], sous_nuage.ys
  end
end
