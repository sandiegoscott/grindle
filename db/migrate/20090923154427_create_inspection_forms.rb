class CreateInspectionForms < ActiveRecord::Migration
  def self.up
    create_table :inspection_forms do |t|
      t.integer :builder_id
      t.datetime :idate
      t.string :address, :city, :state, :zip, :jobnumber, :status, :itype
      t.boolean :passed, :rinpreq, :corpro, :houseclean, :elcmeter, :gasmeter, :appliances, :rpassed, :rrinpreq, :rcorpro, :rhouseclean, :relecmeter, :rgasmeter, :rappliances
      t.timestamps
      t.integer :subdivision_id, :inspector_id, :superintendent_id, :areamanger_id
      t.datetime :ridate
      t.integer :rinspector_id
      t.boolean :otsr, :oti, :otb
    end
  end

  def self.down
    drop_table :inspection_forms
  end
end
