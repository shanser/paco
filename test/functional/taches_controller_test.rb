require 'test_helper'

class TachesControllerTest < ActionController::TestCase
  
  test "should get index" do
    bouchonne_le_temps
    cree_taches_finies [0, 0], [2, 4]
    cree_taches_non_finies [4]

    get :index
    assert_response :success
    assert_not_nil assigns(:taches)
    assert_equal "Paco prédit que le projet se finira le 09 January 2001", assigns(:prediction_date_fin)
  end

  test "sait gérer le cas où il n'y a pas assez de tâches terminées pour prédire la fin du projet" do
    get :index
    assert_response :success
    assert_equal 'Paco ne sait pas encore prédire la date de fin du projet', assigns(:prediction_date_fin)
  end
  
  test "sait gérer le cas où il le projet est interminable à ce rythme" do
    bouchonne_le_temps
    cree_taches_finies [0, 0], [0, 1]
    cree_taches_non_finies [0, 1, 1, 1]

    get :index
    assert_response :success
    assert_equal "Paco prédit que le projet ne se terminera jamais à ce rythme", assigns(:prediction_date_fin)
  end
  
  test "sait gérer la pondération" do
    bouchonne_le_temps
    cree_taches_finies [0, 0], [2, 4]
    Factory :tache, :date_entree => demarrage + 4.days, :poids => 2

    get :index
    assert_response :success
    assert_not_nil assigns(:taches)
    assert_equal "Paco prédit que le projet ne se terminera jamais à ce rythme", assigns(:prediction_date_fin)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tache" do
    assert_difference('Tache.count') do
      post :create, :tache => { }
    end

    assert_redirected_to tache_path(assigns(:tache))
  end

  test "should show tache" do
    get :show, :id => Factory(:tache)
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => Factory(:tache)
    assert_response :success
  end

  test "should update tache" do
    put :update, :id => Factory(:tache), :tache => { }
    assert_redirected_to tache_path(assigns(:tache))
  end

  test "should destroy tache" do
    tache = Factory(:tache)
    assert_difference('Tache.count', -1) do
      delete :destroy, :id => tache
    end

    assert_redirected_to taches_path
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
end
