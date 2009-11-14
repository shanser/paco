require 'test_helper'

class PredictionTest < ActiveSupport::TestCase

  def nouvelle_prediction nuage_points_entrees, nuage_points_sorties, projet_termine
    Prediction.new nuage_points_entrees, nuage_points_sorties, 0, date_reference, projet_termine
  end

  test 'projection impossible' do
    nuage_points_entrees = NuagePoints.new [0], [3]
    nuage_points_sorties = NuagePoints.new [], []
    prediction = nouvelle_prediction nuage_points_entrees, nuage_points_sorties, false

    assert prediction.impossible?
    assert_equal 'projet.projection_impossible', prediction.diagnostic
    assert_equal 'Paco ne sait pas encore prédire la date de fin du projet', prediction.to_s
  end
  
  test 'projet interminable' do
    nuage_points_entrees = NuagePoints.new [0, 2], [3, 4]
    nuage_points_sorties = NuagePoints.new [2], [1]

    prediction = nouvelle_prediction nuage_points_entrees, nuage_points_sorties, false
    assert_equal 'projet.interminable', prediction.diagnostic
  end
  
  test 'projet de durée prédictible' do
    nuage_points_entrees = NuagePoints.new [0], [3]
    nuage_points_sorties = NuagePoints.new [2, 4], [1, 2]

    prediction = nouvelle_prediction nuage_points_entrees, nuage_points_sorties, false
    assert_equal 'projet.prediction', prediction.diagnostic
    assert_equal 6.days, prediction.duree_projet
  end
  
  test 'projet terminé' do
    nuage_points_entrees = NuagePoints.new [0], [2]
    nuage_points_sorties = NuagePoints.new [2, 4], [1, 2]

    prediction = nouvelle_prediction nuage_points_entrees, nuage_points_sorties, true
    assert_equal 'projet.termine', prediction.diagnostic
  end
end