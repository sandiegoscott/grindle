class Subdivision < ActiveRecord::Base
  acts_as_authorization_object
  has_many :inspection_forms
  has_many :final_inspections
  has_many :frame_inspections
  has_many :defects, :through => :inspection_forms
  has_many :rbuilders, :through => :final_inspections
  
  validates_uniqueness_of :name

  def <=>( other )
    name <=> other.name
  end

end

