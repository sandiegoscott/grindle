class Defect < ActiveRecord::Base
  acts_as_authorization_object
  belongs_to :category
  belongs_to :inspection_form

  belongs_to :subdivision   # keys added during creation
  belongs_to :rbuilder

end

