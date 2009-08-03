require 'test_helper'

class TacheTest < ActiveSupport::TestCase

  test "une tâche doit avoir un poids par défaut de 1" do
    assert_equal 1, Tache.new.poids
  end
end
