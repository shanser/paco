require 'test_helper'

class ProjetTest < ActiveSupport::TestCase
  attr_reader :demarrage, :projet
  
  subject {@projet}
  should_have_many :taches
  
  def setup
    @projet = Projet.new
    @demarrage = date_reference
    @projet.stubs :taches => stub(:minimum => demarrage, :all? => false)
    Time.stubs(:now => demarrage + 4.days)
    Tache.stubs(:minimum => @demarrage)
    Tache.stubs(:all => [stub(:terminee? => false)])
  end

  test "génère une exception quand il n'y a aucune tâche terminée" do
    bouchonne_taches_entrees [0], [3]
    bouchonne_taches_sorties [], []
    
    assert_equal "projet.projection_impossible", projet.prediction_paco.diagnostic
  end
  
  test "génère une exception quand le backlog se remplit aussi vite qu'il se vide" do
    bouchonne_taches_entrees [0, 2], [3, 4]
    bouchonne_taches_sorties [2], [1]
    
    assert_equal "projet.interminable", projet.prediction_paco.diagnostic
  end
  
  test "génère une exception quand la projection est inférieure à la date du jour" do
    bouchonne_taches_entrees [0, 1], [3, 3]
    bouchonne_taches_sorties [0, 1], [1, 1]
    
    assert_equal "projet.interminable", projet.prediction_paco.diagnostic
  end

  test "sait calculer date projection fin quand le backlog ne bouge pas" do
    bouchonne_taches_entrees jours_apres_demarrage = [0], nb_taches_a_ces_jours = [3]
    bouchonne_taches_sorties [2, 4], [1, 1]

    assert_prediction_duree_projet_equal 6.days, projet.prediction_paco
  end

  test "sait calculer date projection fin quand le backlog évolue" do
    bouchonne_taches_entrees jours_apres_demarrage = [0, 4], nb_taches_a_ces_jours = [2, 1]
    bouchonne_taches_sorties [2, 4], [1, 1]

    assert_prediction_duree_projet_equal 8.days, projet.prediction_paco
  end
  
  test "nombre_taches_par_date rajoute un point au nuage si la dernière date retournée n'est pas aujourd'hui" do
    Time.stubs(:now => demarrage + 6.days)

    bouchonne_taches_entrees [], []
    bouchonne_taches_sorties [0, 4], [1, 1]

    assert_equal "0,6|0,0|0,4,6|1,2,2", projet.google_graph[:data]
  end
  
  test "un projet sans date de stabilisation backlog met une verticale à l'origine dans le google graph" do
    bouchonne_taches_entrees [0], [4]
    bouchonne_taches_sorties [], []

    assert_equal "0,0|0,4", projet.google_graph[:stabilisation_backlog]
  end
  
  test "un projet avec date de stabilisation backlog met un verticale à cette date dans le google graph" do
    @projet.date_stabilisation_backlog = demarrage + 2.days
    bouchonne_taches_entrees [0], [4]
    bouchonne_taches_sorties [], []

    assert_equal "2,2|0,4", projet.google_graph[:stabilisation_backlog]
  end

  test "cumuls d'un singleton est ce singleton lui-même" do
    assert_equal [1], cumuls([1])
  end
  
  test "cumuls d'un doublon cumule la somme sur la deuxième valeur du doublon" do
    assert_equal [1, 3], cumuls([1, 2])
  end
  
  test "cumuls d'un triplet cumule la somme des éléments précédents" do
    assert_equal [1, 2, 3], cumuls([1, 1, 1])
  end
  
  private
  
  def assert_prediction_duree_projet_equal duree_attendue, prediction
    assert_equal 'projet.prediction', prediction.diagnostic
    assert_equal duree_attendue, prediction.duree_projet
  end
  
  def bouchonne_requete_taches resultat_requete, parametres
    projet.taches.stubs(:sum).
          with(:poids, parametres).
          returns(resultat_requete)
  end

  def bouchonne_taches_entrees clefs, valeurs
    bouchonne_requete_taches (faux_resultat clefs, valeurs), {:order => :date_entree, :group => :date_entree}
  end
  
  def bouchonne_taches_sorties clefs, valeurs
    bouchonne_requete_taches (faux_resultat clefs, valeurs), {:order => :date_sortie, :group => :date_sortie, :conditions => "date_sortie IS NOT NULL"}
  end
  
  def faux_resultat clefs, valeurs
    dates = clefs.map { |clef| demarrage + clef.days}
    retour = ActiveSupport::OrderedHash.new
    dates.each_with_index do |date, index|
      retour[date] = valeurs[index]
    end
    retour
  end
end