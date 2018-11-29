class Category < ActiveRecord::Base
  acts_as_authorization_object

  has_many :defects
  
  validates_uniqueness_of :name

  def <=>( other )
    name <=> other.name
  end

end

