class AddDrHortonFields < ActiveRecord::Migration
  def self.up
    change_table :inspection_forms do |t|
      t.boolean   :dr_horton
      t.string    :name, :limit => 60
      t.string    :phone, :limit => 20
      t.string    :his_phone, :limit => 20
      t.string    :her_phone, :limit => 20
      t.boolean   :kitchen, :bathrooms, :painting, :doors, :house_keys, :windows, :floors, :fireplace, :brick, :roof
      t.boolean   :exterior, :operation, :detectors, :electrical1, :electrical2, :concrete, :lot, :locations, :warranty, :utility
    end

    change_table :defects do |t|
      t.string    :status, :limit => 12  # 'Pending', 'Incomplete', 'Complete'
      t.datetime  :date_called
      t.boolean   :is_called
      t.datetime  :date_completed
      t.boolean   :is_completed
    end
  end

  def self.down
  end
end
