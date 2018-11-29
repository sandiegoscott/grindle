class Areamanager < User
  belongs_to :rbuilder
  has_many :superintendents, :through => :inspection_forms
  has_many :inspection_forms, :foreign_key => "areamanger_id"
  has_many :final_inspections, :foreign_key => "areamanger_id"
  has_many :frame_inspections, :foreign_key => "areamanger_id"
  has_many :defects, :through => :inspection_forms
end
