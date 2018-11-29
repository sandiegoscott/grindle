class RemoveReinspections < ActiveRecord::Migration
  def self.up
    drop_table :reinspections
  end

  def self.down
  end
end
