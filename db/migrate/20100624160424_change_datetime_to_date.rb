class ChangeDatetimeToDate < ActiveRecord::Migration
  def self.up
    change_table :inspection_forms do |t|
      t.change :idate, :date
      t.change :ridate, :date
    end
  end

  def self.down
    change_table :inspection_forms do |t|
      t.change :idate, :datetime
      t.change :ridate, :datetime
    end
  end
end

