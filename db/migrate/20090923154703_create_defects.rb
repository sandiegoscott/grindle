class CreateDefects < ActiveRecord::Migration
  def self.up
    create_table :defects do |t|
      t.integer :inspection_form_id
      t.string :name
      t.timestamps
      t.integer :category_id
    end
  end

  def self.down
    drop_table :defects
  end
end
