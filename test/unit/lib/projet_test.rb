require 'test_helper'

class ProjetTest < ActiveSupport::TestCase
  
  test "sait calculer date projection fin" do
    projet = Projet.new
    assert_equal 4, projet.projection_date_fin
  end
end