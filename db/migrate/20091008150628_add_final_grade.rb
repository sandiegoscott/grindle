class AddFinalGrade < ActiveRecord::Migration
  def self.up
    add_column :inspection_forms, :fgpass, :boolean
    add_column :inspection_forms, :fgcap, :boolean
    add_column :inspection_forms, :fgcfr, :boolean    
  end

  def self.down
    remove_column :inspection_forms, :fgpass
    remove_column :inspection_forms, :fgcap
    remove_column :inspection_forms, :fgcfr
  end
end
