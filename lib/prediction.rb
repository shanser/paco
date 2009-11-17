class Prediction
  attr_reader :diagnostic, :duree_projet

  def initialize nuage_points_entrees, nuage_points_sorties, abscisse_debut_regression, date_debut_projet, projet_termine
    @date_debut_projet = date_debut_projet.nil? ? Time.now : date_debut_projet
    @diagnostic = 'projet.termine'
    @duree_projet = 0.days
    
    unless projet_termine
      calcule_duree_projet nuage_points_entrees, nuage_points_sorties, abscisse_debut_regression
    end
  end
  
  def impossible?
    @diagnostic == 'projet.projection_impossible'
  end
  
  def to_s
    I18n.t(@diagnostic, :date => I18n.l(@date_debut_projet + @duree_projet))
  end
  
  
  
  
  private
  
  def calcule_duree_projet nuage_points_entrees, nuage_points_sorties, abscisse_debut_regression
    begin
      abcisse_intersection = intersection_nuage_points nuage_points_entrees, nuage_points_sorties, abscisse_debut_regression
      @duree_projet = abcisse_intersection.days
      @diagnostic = (@duree_projet <= 0) ? 'projet.interminable' : 'projet.prediction' 
    rescue Paco::CalculProjectionImpossible
      @diagnostic = 'projet.projection_impossible'
    end
  end
  
  def intersection_nuage_points nuage_entrees, nuage_sorties, debut_regression
    droite_entrees = nuage_entrees.regression_lineaire debut_regression
    droite_sorties = nuage_sorties.regression_lineaire debut_regression
    droite_entrees.abcisse_intersection_avec droite_sorties
  end
end