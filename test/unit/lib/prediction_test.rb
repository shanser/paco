require 'test_helper'

class PredictionTest < ActiveSupport::TestCase

  test "initialisation" do
    prediction = Prediction.new "un diagnostic", date_reference
    assert_equal "un diagnostic", prediction.diagnostic
    assert_equal date_reference, prediction.date
  end
end