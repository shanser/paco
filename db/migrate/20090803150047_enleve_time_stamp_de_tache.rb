class EnleveTimeStampDeTache < ActiveRecord::Migration
  def self.up
    remove_timestamps :taches
  end

  def self.down
    add_timestamps :taches
  end
end
