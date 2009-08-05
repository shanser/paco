def cumuls valeurs
  resultat =[]

  valeurs.inject(0) do |cumul, valeur|
    cumul += valeur
    resultat << cumul
    cumul
  end

  resultat
end


class Projet
  
  def self.projection_date_fin
    timestamps_dates_sortie, nombre_taches_finies_a_ces_dates = nombre_taches_finies_par_date
    Time.at timestamp_projection(timestamps_dates_sortie, nombre_taches_finies_a_ces_dates)
  end
  

  private
  def self.timestamp_projection timestamps_dates_sortie, nombre_taches_finies_a_ces_dates
    raise Paco::CalculProjectionImpossible if timestamps_dates_sortie.size < 2
    lineFit = LineFit.new
    lineFit.setData timestamps_dates_sortie, nombre_taches_finies_a_ces_dates
    ordonnee_origine, pente = lineFit.coefficients
    
    (Tache.count - ordonnee_origine) / pente
  end

  def self.nombre_taches_finies_par_date
    result = Tache.count(:group => :date_sortie, :order => :date_sortie, :conditions => "date_sortie IS NOT NULL")
    [result.keys.map{|t| t.to_time.to_i}, cumuls(result.values)]
  end
end