require 'test_helper'
require 'Projet'


class ProjetTest < ActiveSupport::TestCase
  
  test "sait calculer date projection fin" do
    demarrage = date_reference
    dates_sortie = [demarrage + 2.days, demarrage + 4.days]
    nombre_taches_finies_a_ces_dates = [1, 1]
    resultat_requete = stub(:keys => dates_sortie, :values => nombre_taches_finies_a_ces_dates)
    date_attendue = demarrage + 6.days

    bouchonne_requetes_base resultat_requete, nb_total_taches = 3

    assert_equal date_attendue, Projet.projection_date_fin
  end

  test "génère une exception quand il n'y a pas assez de données pour calculer la régression" do
    demarrage = date_reference
    dates_sortie = [demarrage + 2.days]
    nombre_taches_finies_a_ces_dates = [1]
    resultat_requete = stub(:keys => dates_sortie, :values => nombre_taches_finies_a_ces_dates)

    bouchonne_requetes_base resultat_requete, nb_total_taches = 3
    
    assert_raise Paco::CalculProjectionImpossible do
      Projet.projection_date_fin
    end
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
  def bouchonne_requetes_base resultat_requete, nb_total_taches
    Tache.stubs(:count => nb_total_taches)
    Tache.stubs(:count).
          with(:order => :date_sortie, :group => :date_sortie, :conditions => "date_sortie IS NOT NULL").
          returns(resultat_requete) 
  end
end