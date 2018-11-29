class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_authorization_subject
  
  validates_uniqueness_of :username

  has_and_belongs_to_many :roles

  def is_admin?
    has_role? :admin
  end

  def is_inspector?
    has_role? :inspector
  end

  def is_builder?
    has_role? :builder
  end

  def is_superintendent?
    has_role? :superintendent
  end

  def is_areamanager?
    has_role? :areamanager
  end

  def full_name
    #logger.info(">>>>>>>>>> first_name=#{first_name}")
    first = first_name.slice(0,1).capitalize == first_name.slice(0,1) ? first_name : first_name.capitalize
    #logger.info(">>>>>>>>>> first=#{first}")
    last = last_name.slice(0,1).capitalize == last_name.slice(0,1) ? last_name : last_name.capitalize
    [first, last].join(' ')
  end
end

