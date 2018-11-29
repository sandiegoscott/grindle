class Item < ActiveRecord::Base
  acts_as_authorization_object

  belongs_to :punchlist

  belongs_to :subdivision   # keys added during creation
  belongs_to :rbuilder

end

