class FixBuilderId < ActiveRecord::Migration
  def self.up
    rename_column :users, :builder_id, :rbuilder_id
  end

  def self.down
    rename_column :users, :rbuilder_id, :builder_id
  end
end
