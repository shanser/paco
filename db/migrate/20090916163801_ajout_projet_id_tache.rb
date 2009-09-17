class AjoutProjetIdTache < ActiveRecord::Migration
  def self.up
    add_column :taches, :projet_id, :integer
  end

  def self.down
    remove_column :taches, :projet_id
  end
end
