class CreateSubdivisions < ActiveRecord::Migration
  def self.up
    create_table :subdivisions do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :subdivisions
  end
end
