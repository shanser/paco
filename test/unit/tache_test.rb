require 'test_helper'

class TacheTest < ActiveSupport::TestCase
  should_validate_presence_of :description

  test "une tâche doit avoir un poids par défaut de 1" do
    assert_equal 1, Tache.new.poids
  end
  
  test "changement de statut à blank doit réinitialiser date_sortie à nil" do
    tache = Tache.new :statut => 'OK', :date_sortie => Time.now, :description => 'tâche'
    assert_not_nil tache.date_sortie
    
    tache.statut = ''
    tache.save!
    assert_nil tache.date_sortie    
  end
end
