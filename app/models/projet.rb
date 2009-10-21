class Projet < ActiveRecord::Base
  has_many :taches
 
  def prediction_date_fin
    return :projet_termine if termine?
    begin
      abcisse_intersection = intersection_nuage_points nuage_points_entrees, nuage_points_sorties, x_debut_regression
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
    x_stabilisation = jours_depuis_debut_projet date_stabilisation_backlog.to_i
    retour[:stabilisation_backlog] = "#{x_stabilisation},#{x_stabilisation}|0,#{retour[:max_y]}"
    retour
  end
  
  def date_stabilisation_backlog
    self[:date_stabilisation_backlog] || date_debut
  end
  
  def graphe_historique
    abcisses, ordonnees = historique_projections
    
    retour = {}
    retour[:max_x] = abcisses.max
    retour[:max_y] = ordonnees.max
    abcisses = abcisses.join(',')
    ordonnees = ordonnees.join(',')
    retour[:data] = [abcisses, ordonnees].join('|')
    retour
  end
  
  private
  
  def nuage_points_entrees derniere_date = nil
    parametres_requete = {:group => :date_entree, :order => :date_entree}
    parametres_requete[:conditions] = ["date_entree < ?", (derniere_date+1.day).to_s(:db)] unless derniere_date.nil?
    x_date = derniere_date.nil? ? nil : jours_depuis_debut_projet(derniere_date.to_i)
    
    nuage_points parametres_requete, x_date
  end
  
  def nuage_points_sorties derniere_date = nil
    parametres_requete = {:group => :date_sortie, :order => :date_sortie, :conditions => "date_sortie IS NOT NULL"}
    parametres_requete[:conditions] = ["date_sortie IS NOT NULL AND date_sortie < ?", (derniere_date+1.day).to_s(:db)] unless derniere_date.nil?
    x_date = derniere_date.nil? ? nil : jours_depuis_debut_projet(derniere_date.to_i)
    
    nuage_points parametres_requete, x_date
  end
 
  def nuage_points parametres_requete, derniere_date = nil
    result = taches.sum(:poids, parametres_requete)
    
    xs = result.keys.map{|t| jours_depuis_debut_projet t.to_i}
    ys = cumuls(result.values)
    
    if xs.first != 0
      xs = [0] + xs
      ys = [0] + ys
    end

    aujourd_hui = jours_depuis_debut_projet(Time.now.beginning_of_day.to_i)
    derniere_date = aujourd_hui if derniere_date.nil?
    if xs.last != derniere_date
      xs << derniere_date
      ys << (ys.last.nil? ? 0 : ys.last)
    end

    NuagePoints.new xs, ys
  end
  
  
  def timestamp_debut
    date_minimum = date_debut
    date_minimum.nil? ? 0 : date_minimum.to_i
  end
  
  def jours_depuis_debut_projet valeur
    (valeur - timestamp_debut) / 86400
  end
  
  def termine?
    taches.all? {|tache| tache.terminee?}
  end
  
  def date_debut
    taches.minimum(:date_entree)
  end
  
  def x_debut_regression
    jours_depuis_debut_projet date_stabilisation_backlog.to_i
  end
  
  def intersection_nuage_points nuage_entrees, nuage_sorties, debut_regression
    droite_entrees = nuage_entrees.regression_lineaire debut_regression
    droite_sorties = nuage_sorties.regression_lineaire debut_regression
    droite_entrees.abcisse_intersection_avec droite_sorties
  end
  
  def historique_projections
    couples = []
    1.upto(nuage_points_entrees.max_x) do |n|
      date = date_debut + n.days
      nuage_entrees = nuage_points_entrees date
      nuage_sorties = nuage_points_sorties date

      begin
        abcisse_intersection = intersection_nuage_points nuage_entrees, nuage_sorties, x_debut_regression
        abcisse_intersection = abcisse_intersection.ceil
      rescue Paco::CalculProjectionImpossible
        abcisse_intersection = 0
      end
      couples << [n, abcisse_intersection]
    end
    couples.unzip
  end
end

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
