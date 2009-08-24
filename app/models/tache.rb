class Tache < ActiveRecord::Base
  validates_presence_of :description
  
  def before_save
    self.date_sortie = nil if statut.blank?
  end
end
