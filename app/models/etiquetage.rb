class Etiquetage < ActiveRecord::Base
  belongs_to :tache
  belongs_to :tag
  validates_presence_of :tache, :tag
end
