class AddDefaultCity < ActiveRecord::Migration
  def self.up
    add_column :users, :default_city, :string, :limit => 30
  end

  def self.down
    remove_column :users, :default_city
  end
end
