class AddSlugToInspection < ActiveRecord::Migration
  def self.up
    change_table :inspection_forms do |t|
      t.string :slug
    end
  end

  def self.down
    remove_column :inspection_forms, :slug
  end
end

