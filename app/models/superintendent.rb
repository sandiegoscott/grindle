class Superintendent < User
  belongs_to :rbuilder
  has_many :inspection_forms
  has_many :final_inspections
  has_many :frame_inspections
  has_many :defects, :through => :inspection_forms
end
