class CreateProjets < ActiveRecord::Migration
  def self.up
    create_table :projets, :force => true do |t|
    end
    projet = Projet.create
    Tache.all.each do |tache|
      projet.taches << tache
    end
  end

  def self.down
    drop_table :projets
  end
end
