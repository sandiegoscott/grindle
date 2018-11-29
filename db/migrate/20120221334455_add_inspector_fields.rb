class AddInspectorFields < ActiveRecord::Migration
  def self.up
    add_column :users, :group_name, :string, :limit => 50
    add_column :users, :office,     :string, :limit => 20
    add_column :users, :mobile,     :string, :limit => 20
    add_column :users, :fax,        :string, :limit => 20
  end

  def self.down
    remove_column :users, :group_name
    remove_column :users, :office
    remove_column :users, :mobile
    remove_column :users, :fax
  end
end
