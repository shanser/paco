class AddDateStabilisationBacklogProjets < ActiveRecord::Migration
  def self.up
    add_column :projets, :date_stabilisation_backlog, :date
  end

  def self.down
    remove_column :projets, :date_stabilisation_backlog
  end
end
