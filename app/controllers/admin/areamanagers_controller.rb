class Admin::AreamanagersController < ApplicationController
  before_filter :require_user
  before_filter :require_rbuilder
  access_control do
    allow :admin
  end

  def index
    @areamanagers = Areamanager.find(:all, :order => 'last_name asc')
  end

  def show
    @areamanager = Areamanager.find(params[:id])
  end

  def new
    @areamanager = Areamanager.new
    @rbuilders = Rbuilder.find(:all, :order => 'username asc')
  end

  def create
    @areamanager = Areamanager.new(params[:areamanager])
    @areamanager.has_role!('areamanager')
    if @areamanager.save
      flash[:notice] = "Successfully created areamanager."
      redirect_to :action => 'index'
    else
      @rbuilders = Rbuilder.find(:all, :order => 'username asc')
      render :action => 'new'
    end
  end

  def edit
    @areamanager = Areamanager.find(params[:id])
    @rbuilders = Rbuilder.find(:all, :order => 'username asc')
  end

  def update
    @areamanager = Areamanager.find(params[:id])
    if @areamanager.update_attributes(params[:areamanager])
      flash[:notice] = "Successfully updated areamanager."
      redirect_to :action => 'index'
    else
      @rbuilders = Rbuilder.find(:all, :order => 'username asc')
      render :action => 'edit'
    end
  end

  def destroy
    @areamanager = Areamanager.find(params[:id])
    @areamanager.destroy
    flash[:notice] = "Successfully destroyed areamanager."
    redirect_to :action => 'index'
  end

end

