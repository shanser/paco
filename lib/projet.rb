def cumuls valeurs
  resultat =[]

  valeurs.inject(0) do |cumul, valeur|
    cumul += valeur
    resultat << cumul
    cumul
  end

  resultat
end

class Date
  def to_i
    to_time.to_i
  end
end

class Projet

  attr_reader :nuage_points_entrees, :nuage_points_sorties

  def initialize
    @nuage_points_entrees = nuage_points({:group => :date_entree, :order => :date_entree})
    @nuage_points_sorties = nuage_points({:group => :date_sortie, :order => :date_sortie, :conditions => "date_sortie IS NOT NULL"})
  end

  def prediction_date_fin
    return :projet_termine if termine?
    begin
      droite_entrees = nuage_points_entrees.regression_lineaire
      droite_sorties = nuage_points_sorties.regression_lineaire
      abcisse_intersection = droite_entrees.abcisse_intersection_avec droite_sorties
    rescue Paco::CalculProjectionImpossible
      return :projection_impossible
    end

    date_projetee =  date_debut + abcisse_intersection.days
    return :projet_interminable if date_projetee < Time.now.to_date
    date_projetee
  end

  def google_graph
    retour = {}
    retour[:max_x] = nuage_points_entrees.max_x
    retour[:max_y] = nuage_points_entrees.max_y
    retour[:data] = [nuage_points_entrees, nuage_points_sorties].map(&:to_google_graph_data).join('|')
    retour
  end
  
  private

  def nuage_points parametres_requete
    result = Tache.sum(:poids, parametres_requete)
    xs = result.keys.map{|t| jours_depuis_debut_projet t.to_i}
    ys = cumuls(result.values)
    
    aujourd_hui = jours_depuis_debut_projet(Time.now.to_date.to_i)
    if xs.last != aujourd_hui
      xs << aujourd_hui
      ys << ys.last
    end
    NuagePoints.new xs, ys
  end
  
  def date_debut
    Tache.minimum(:date_entree)
  end
  
  def timestamp_debut
    date_minimum = date_debut
    date_minimum.nil? ? 0 : date_minimum.to_date.to_i
  end
  
  def jours_depuis_debut_projet valeur
    (valeur - timestamp_debut) / 86400
  end
  
  def termine?
    Tache.all.all? {|tache| tache.terminee?}
  end
end


