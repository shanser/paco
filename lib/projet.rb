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

  def self.projection_date_fin
    nuage_points = nuage_points_entrees
    droite_entrees = nuage_points.regression_lineaire
    droite_sorties = nuage_points_sorties.regression_lineaire

    date_projetee =  date_debut + timestamp_projection(droite_entrees, droite_sorties).days
    raise Paco::ProjetInterminable if date_projetee < Time.now.to_date
    date_projetee
  end

  def self.nuage_points_entrees
    nuage_points({:group => :date_entree, :order => :date_entree})
  end

  def self.nuage_points_sorties
    nuage_points({:group => :date_sortie, :order => :date_sortie, :conditions => "date_sortie IS NOT NULL"})
  end
  
  def self.google_graph
    retour = {}
    retour[:max_x] = nuage_points_entrees.max_x
    retour[:max_y] = nuage_points_entrees.max_y
    retour[:data] = [nuage_points_entrees, nuage_points_sorties].map(&:to_google_graph_data).join('|')
    retour
  end
  
  private
  def self.timestamp_projection droite_entrees, droite_sorties
    droite_entrees.abcisse_intersection_avec droite_sorties
  end
  
  def self.nuage_points parametres_requete
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
  
  def self.date_debut
    Tache.minimum(:date_entree)
  end
  
  def self.timestamp_debut
    date_minimum = date_debut
    date_minimum.nil? ? 0 : date_minimum.to_date.to_i
  end
  
  def self.jours_depuis_debut_projet valeur
    (valeur - timestamp_debut) / 86400
  end
end


