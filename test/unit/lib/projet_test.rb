require 'test_helper'
require 'projet.rb'


class ProjetTest < ActiveSupport::TestCase
  attr_reader :demarrage
  
  def setup
    @demarrage = date_reference
    Time.stubs(:now => demarrage + 4.days)
    Tache.stubs(:minimum => @demarrage)
    Tache.stubs(:all => [stub(:terminee? => false)])
  end

  test "génère une exception quand il n'y a aucune tâche terminée" do
    bouchonne_taches_entrees [0], [3]
    bouchonne_taches_sorties [], []
    
    assert_equal :projection_impossible, projet.prediction_date_fin
  end
  
  test "génère une exception quand le backlog se remplit aussi vite qu'il se vide" do
    bouchonne_taches_entrees [0], [3]
    bouchonne_taches_sorties [2], [1]
    
    assert_equal :projection_impossible, projet.prediction_date_fin
  end
  
  test "génère une exception quand la projection est inférieure à la date du jour" do
    bouchonne_taches_entrees [0, 1], [3, 3]
    bouchonne_taches_sorties [0, 1], [1, 1]
    
    assert_equal :projet_interminable, projet.prediction_date_fin
  end

  test "sait calculer date projection fin quand le backlog ne bouge pas" do
    bouchonne_taches_entrees jours_apres_demarrage = [0], nb_taches_a_ces_jours = [3]
    bouchonne_taches_sorties [2, 4], [1, 1]
    date_attendue = demarrage + 6.days

    assert_equal date_attendue, projet.prediction_date_fin
  end

  test "sait calculer date projection fin quand le backlog évolue" do
    bouchonne_taches_entrees jours_apres_demarrage = [0, 4], nb_taches_a_ces_jours = [2, 1]
    bouchonne_taches_sorties [2, 4], [1, 1]
    date_attendue = demarrage + 8.days

    assert_equal date_attendue, projet.prediction_date_fin
  end
  
  test "nombre_taches_par_date rajoute un point au nuage si la dernière date retournée n'est pas aujourd'hui" do
    Time.stubs(:now => demarrage + 6.days)

    bouchonne_taches_entrees [], []
    bouchonne_taches_sorties [2, 4], [1, 1]

    nuage = projet.nuage_points_sorties
    assert_equal 3, nuage.size
    assert_equal [2, 4, 6], nuage.xs
    assert_equal [1, 2, 2], nuage.ys 
  end

  test "sait renvoyer les donnees au format google graph" do
    bouchonne_taches_entrees [0, 4], [2, 1]
    bouchonne_taches_sorties [2, 4], [1, 1]
    
    assert_equal '0,4|2,3|2,4|1,2', projet.google_graph[:data]
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
  def bouchonne_requete_taches resultat_requete, parametres
    Tache.stubs(:sum).
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
    stub(:keys => dates, :values => valeurs)
  end
  
  def projet
    Projet.new
  end
end