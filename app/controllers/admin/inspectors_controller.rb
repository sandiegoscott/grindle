class Admin::InspectorsController < ApplicationController
  before_filter :require_user
  before_filter :get_rbuilder

  access_control do
    allow :admin
  end

  def index
    @inspectors = Inspector.find(:all, :order => 'last_name asc')
  end

  def show
    @inspector = Inspector.find(params[:id])
  end

  def new
    @inspector = Inspector.new
  end

  def create
    @inspector = Inspector.new(params[:inspector])
    @inspector.has_role!('inspector')
    if @inspector.save
      flash[:notice] = "Successfully created inspector."
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @inspector = Inspector.find(params[:id])
  end

  def update
    @inspector = Inspector.find(params[:id])
    if @inspector.update_attributes(params[:inspector])
      flash[:notice] = "Successfully updated inspector."
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @inspector = Inspector.find(params[:id])
    @inspector.destroy
    flash[:notice] = "Successfully destroyed inspector."
    redirect_to :action => 'index'
  end

  protected

end

