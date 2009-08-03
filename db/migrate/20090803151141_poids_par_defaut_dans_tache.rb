class PoidsParDefautDansTache < ActiveRecord::Migration
  def self.up
    change_column_default :taches, :poids, 1
  end

  def self.down
  end
end
