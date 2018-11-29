class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :inspection_form_id, :creator_id
      t.string :info
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
