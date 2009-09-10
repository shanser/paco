require 'test_helper'

class TachesControllerTest < ActionController::TestCase
  
  def setup
    bouchonne_le_temps
  end
  
  test "should get index" do
    cree_taches_finies [0, 0], [2, 3]
    cree_taches_non_finies [3, 3]

    get :index
    assert_prediction_paco_equal "Paco prédit que le projet se finira le 10 janvier 2001"
    gg = assigns(:google_graph)
    assert_equal [3, 4, '0,3|2,4|2,3|1,2'], [gg[:max_x], gg[:max_y], gg[:data]] 
  end
  
  test "sait gérer le cas où le projet est interminable à ce rythme" do
    cree_taches_finies [0, 0], [0, 1]
    cree_taches_non_finies [0, 1, 1, 1]

    get :index
    assert_prediction_paco_equal "Paco prédit que le projet ne se terminera jamais à ce rythme"
  end
  
  test "sait gérer la pondération" do
    cree_taches_finies [0, 0], [2, 4]
    Factory :tache, :date_entree => demarrage + 4.days, :poids => 2

    get :index
    assert_prediction_paco_equal "Paco prédit que le projet ne se terminera jamais à ce rythme"
  end
  
  test "sait gérer les projets terminés" do
     cree_taches_finies [0, 0], [0, 1]
     
     get :index
     assert_prediction_paco_equal 'Paco constate que le projet est terminé'
  end

  private
  def cree_taches_finies dates_entree, dates_sortie
    dates = dates_entree.zip(dates_sortie)
    dates.map{|i| Factory(:tache, :statut => 'OK', :date_entree => demarrage + i.first.days, :date_sortie => demarrage + i.last.days)}
  end
  
  def cree_taches_non_finies dates_entree
    dates_entree.map{ |i| Factory(:tache, :date_entree => demarrage + i.days) }
  end
  
  def bouchonne_le_temps
    @demarrage = date_reference
    self.class.send :attr_reader, :demarrage
    Time.stubs(:now => demarrage + 4.days)
  end
  
  def assert_prediction_paco_equal prediction
    assert_response :success
    assert_equal prediction, assigns(:prediction_date_fin)
    assert_not_nil assigns(:taches)
  end
end
