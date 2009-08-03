class CreateTaches < ActiveRecord::Migration
  def self.up
    create_table :taches do |t|
      t.text :description
      t.text :commentaire
      t.integer :poids
      t.string :statut
      t.date :date_entree
      t.date :date_sortie

      t.timestamps
    end
  end

  def self.down
    drop_table :taches
  end
end
