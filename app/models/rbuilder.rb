class Rbuilder < User
  has_many :superintendents, :dependent => :destroy
  has_many :areamanagers, :dependent => :destroy
  has_many :inspection_forms, :dependent => :destroy
  has_many :final_inspections, :dependent => :destroy
  has_many :frame_inspections, :dependent => :destroy
  has_many :defects, :through => :inspection_forms, :dependent => :destroy
  has_many :subdivisions, :through => :inspection_forms
  has_many :punchlists, :dependent => :destroy

  def is_drhorton?
    username.include? "drhorton"
  end
end

