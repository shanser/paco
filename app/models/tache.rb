class Tache < ActiveRecord::Base
  def before_save
    self.date_sortie = nil if statut.blank?
  end
end
