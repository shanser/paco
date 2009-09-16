class AjoutProjetIdTache < ActiveRecord::Migration
  def self.up
    add_column :taches, :projet_id, :integer
    projet = Projet.first
    Tache.all.each do |tache|
      projet.taches << tache
    end
  end

  def self.down
    remove_column :taches, :projet_id
  end
end
