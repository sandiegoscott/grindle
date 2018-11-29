class InspectionsController < ApplicationController
  before_filter :require_user
  
  access_control do
    allow :admin, :builder, :inspector, :areamanager
  end
  
  def index
    
  end
end
