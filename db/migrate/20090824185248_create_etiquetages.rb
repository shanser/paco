class CreateEtiquetages < ActiveRecord::Migration
  def self.up
    create_table :etiquetages do |t|
      t.references :tache
      t.references :tag
    end
  end

  def self.down
    drop_table :etiquetages
  end
end
