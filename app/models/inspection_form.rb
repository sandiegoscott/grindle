class InspectionForm < ActiveRecord::Base
  acts_as_authorization_object

  self.inheritance_column = :itype
  has_many   :defects,  :dependent => :destroy
  has_many   :comments, :dependent => :destroy
  has_many   :categories, :through => :defects
  belongs_to :subdivision
  belongs_to :inspector
  belongs_to :superintendent
  belongs_to :areamanager, :foreign_key => "areamanger_id"
  belongs_to :rbuilder

  accepts_nested_attributes_for :defects,  :reject_if => lambda { |attributes| attributes['name'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a.values.all?(&:blank?) }, :allow_destroy => true

  validates_presence_of :superintendent_id, :message => "can't be blank"
  validates_presence_of :areamanger_id, :message => "can't be blank"
  validates_presence_of :jobnumber, :message => "can't be blank"
  validates_presence_of :address, :message => "can't be blank"
  validates_presence_of :city, :message => "can't be blank"

  def after_validation_on_create
    self.slug = ActiveSupport::SecureRandom.hex(8)
  end

end

