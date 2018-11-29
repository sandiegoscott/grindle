class Inspector < User
  has_many :inspection_forms
  has_many :final_inspections
  has_many :frame_inspections
end
