class Admin::SuperintendentsController < ApplicationController
  before_filter :require_user
  before_filter :get_rbuilder

  access_control do
    allow :admin
  end

  def index
    @superintendents = Superintendent.find(:all, :order => 'last_name asc')
  end

  def show
    @superintendent = Superintendent.find(params[:id])
  end

  def new
    @superintendent = Superintendent.new
    @rbuilders = Rbuilder.find(:all, :order => 'username asc')
  end

  def create
    @superintendent = Superintendent.new(params[:superintendent])
    @superintendent.has_role!('superintendent')
    if @superintendent.save
      flash[:notice] = "Successfully created superintendent."
      redirect_to :action => 'index'
    else
      @rbuilders = Rbuilder.find(:all, :order => 'username asc')
      render :action => 'new'
    end
  end

  def edit
    @superintendent = Superintendent.find(params[:id])
    @rbuilders = Rbuilder.find(:all, :order => 'username asc')
  end

  def update
    @superintendent = Superintendent.find(params[:id])
    if @superintendent.update_attributes(params[:superintendent])
      flash[:notice] = "Successfully updated superintendent."
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @superintendent = Superintendent.find(params[:id])
    @superintendent.destroy
    flash[:notice] = "Successfully destroyed superintendent."
    redirect_to :action => 'index'
  end

end

