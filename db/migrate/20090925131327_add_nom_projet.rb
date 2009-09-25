class AddNomProjet < ActiveRecord::Migration
  def self.up
    add_column :projets, :nom, :string, :default => 'Demo'
  end

  def self.down
    remove_column :projets, :nom
  end
end
