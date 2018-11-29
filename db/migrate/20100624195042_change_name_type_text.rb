class ChangeNameTypeText < ActiveRecord::Migration
  def self.up
    change_table :defects do |t|
      t.change :name, :text, :limit => 800
    end

    change_table :comments do |t|
      t.change :info, :text, :limit => 800
    end
  end

  def self.down
    change_table :defects do |t|
      t.change :name, :string
    end

    change_table :comments do |t|
      t.change :info, :string
    end
  end
end

