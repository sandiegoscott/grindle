class OverviewController < ApplicationController
  before_filter :require_user
  before_filter :get_rbuilder

  #access_control do
  #  allow logged_in, :to => :index
  #end

  def index
    logger.info(">>>>> current_user=#{current_user.inspect}")
    logger.info(">>>>> @rbuilder=#{@rbuilder.inspect}")
    @rbuilders = Rbuilder.find(:all, :order => 'username asc')
  end

  def show
    # get the builder
    @rbuilder = Rbuilder.find(params[:id])
    session[:rbuilder_id] = params[:id]

    # if we're admin or inspector, put up index
    if current_user.is_admin? || current_user.is_inspector?
      index
      render :action => :index
    end
  end

end

