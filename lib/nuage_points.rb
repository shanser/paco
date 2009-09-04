class NuagePoints
  attr_reader :xs, :ys, :timestamp_debut
  
  def initialize xs, ys
    @xs, @ys = xs, ys
  end
  
  def size
    xs.size
  end
  
  def first
    Point.new xs.first, ys.first
  end

  def regression_lineaire
    raise Paco::CalculProjectionImpossible if size == 0
    return Droite.horizontale(first.y) if size == 1
    
    lineFit = LineFit.new
    lineFit.setData xs, ys
    ordonnee_origine_sorties, pente_sorties = lineFit.coefficients
    Droite.new ordonnee_origine_sorties, pente_sorties
  end
  
  def to_google_graph_data
    [xs, ys].map{|suite| suite.join(',')}
  end
  
  def max_y
    ys.last
  end
  
  def max_x
    xs.last
  end
end



class Droite
  attr_accessor :ordonnee_origine, :pente
  
  def initialize ordonnee_origine, pente
    @ordonnee_origine = ordonnee_origine
    @pente = pente
  end
  
  def self.horizontale ordonnee
    Droite.new ordonnee, 0
  end
  
  def abcisse_intersection_avec autre_droite
    delta_pente = pente - autre_droite.pente
    raise Paco::CalculProjectionImpossible if delta_pente == 0

    (autre_droite.ordonnee_origine - ordonnee_origine) / delta_pente
  end
end



class Point
  attr_reader :x, :y
  def initialize x, y
    @x, @y = x, y
  end
end