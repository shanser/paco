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
    nuage_points = nombre_taches_entrees_par_date
    droite_entrees = nuage_points.regression_lineaire
    droite_sorties = nombre_taches_sorties_par_date.regression_lineaire

    date_projetee = Time.at timestamp_projection(droite_entrees, droite_sorties)
    raise Paco::ProjetInterminable if date_projetee < Time.now
    date_projetee
  end

  def self.nombre_taches_entrees_par_date
    nombre_taches_par_date({:group => :date_entree, :order => :date_entree})
  end

  def self.nombre_taches_sorties_par_date
    nombre_taches_par_date({:group => :date_sortie, :order => :date_sortie, :conditions => "date_sortie IS NOT NULL"})
  end
  
  def self.google_graph_data
    [nombre_taches_entrees_par_date, nombre_taches_sorties_par_date].map(&:to_google_graph_data).join('|')
  end

  def self.google_graph_max_x
    nombre_taches_entrees_par_date.max_x
  end
  
  def self.google_graph_max_y
    nombre_taches_entrees_par_date.max_y
  end
  
  private
  def self.timestamp_projection droite_entrees, droite_sorties
    droite_entrees.abcisse_intersection_avec droite_sorties
  end
  
  def self.nombre_taches_par_date parametres_requete
    result = Tache.sum(:poids, parametres_requete)
    xs = result.keys.map{|t| t.to_i}
    ys = cumuls(result.values)
    
    aujourd_hui = Time.now.to_date.to_i
    if xs.last != aujourd_hui
      xs << aujourd_hui
      ys << ys.last
    end
    NuagePoints.new xs, ys, timestamp_debut
  end
  
  def self.timestamp_debut
    date_minimum = Tache.minimum(:date_entree)
    date_minimum.nil? ? 0 : date_minimum.to_date.to_i
  end
end


