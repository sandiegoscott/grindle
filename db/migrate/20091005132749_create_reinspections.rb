class CreateReinspections < ActiveRecord::Migration
  def self.up
    create_table :reinspections do |t|
      t.integer :inspection_form_id, :inspector_id
      t.datetime :rdate
      t.boolean :passed, :rinspection
      t.timestamps
    end
  end

  def self.down
    drop_table :reinspections
  end
end
