class Comment < ActiveRecord::Base
  acts_as_authorization_object
  belongs_to :inspection_form
end
