require 'test_helper'

class ProjetsControllerTest < ActionController::TestCase
  
  attr_accessor :projet
  
  def setup
    @projet = Projet.create
    bouchonne_le_temps
  end
  
  test "should get show" do
    cree_taches_finies [0, 0], [1, 3]
    cree_taches_non_finies [0, 3]

    get :show
    assert_prediction_paco_equal "Paco prédit que le projet se finira le 10 janvier 2001"
    gg = assigns(:google_graph)
    assert_equal [3, 4, '0,3|3,4|0,1,3|0,1,2'], [gg[:max_x], gg[:max_y], gg[:data]] 
  end
  
  test "sait gérer le cas où le projet est interminable à ce rythme" do
    cree_taches_finies [0, 0], [0, 1]
    cree_taches_non_finies [0, 1, 1, 1]

    get :show
    assert_prediction_paco_equal "Paco prédit que le projet ne se terminera jamais à ce rythme"
  end
  
  test "sait gérer la pondération" do
    cree_taches_finies [0, 0], [2, 4]
    projet.taches << Factory(:tache, :date_entree => demarrage + 4.days, :poids => 3)

    get :show
    assert_prediction_paco_equal "Paco prédit que le projet ne se terminera jamais à ce rythme"
  end
  
  test "sait gérer les projets terminés" do
     cree_taches_finies [0, 0], [0, 1]
     
     get :show
     assert_prediction_paco_equal 'Paco constate que le projet est terminé'
  end
  
  test "sait gérer un projet avec aucune tâche terminée" do
    cree_taches_non_finies [0, 0, 1]

    get :show
    assert_prediction_paco_equal "Paco prédit que le projet ne se terminera jamais à ce rythme"
  end
  
  test "prend en compte la date de stabilisation du backlog" do
    projet.update_attribute(:date_stabilisation_backlog, demarrage + 2.days)
    cree_taches_finies [0, 1], [2, 3]
    cree_taches_non_finies [0, 2, 4]
    
    get :show
    assert_prediction_paco_equal "Paco prédit que le projet se finira le 09 janvier 2001"
  end
  
  test "sait gérer quand aucune tâche n'est terminée après la stabilisation du backlog" do
    projet.update_attribute(:date_stabilisation_backlog, demarrage + 2.days)
    cree_taches_non_finies [0, 0, 1]

    get :show
    assert_prediction_paco_equal "Paco ne sait pas encore prédire la date de fin du projet"
    assert_equal '0,1,3|2,3,3|0,3|0,0', assigns(:google_graph)[:data]
  end

  private
  def cree_taches_finies dates_entree, dates_sortie
    dates = dates_entree.zip(dates_sortie)
    dates.map{|i| projet.taches << Factory(:tache, :statut => 'OK', :date_entree => demarrage + i.first.days, :date_sortie => demarrage + i.last.days)}
  end
  
  def cree_taches_non_finies dates_entree
    dates_entree.map{ |i| projet.taches << Factory(:tache, :date_entree => demarrage + i.days) }
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
