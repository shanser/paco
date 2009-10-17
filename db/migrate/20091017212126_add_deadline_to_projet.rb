class AddDeadlineToProjet < ActiveRecord::Migration
  def self.up
    add_column :projets, :deadline, :date
  end

  def self.down
    remove_column :projets, :deadline
  end
end
