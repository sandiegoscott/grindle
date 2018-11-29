class Admin::SubdivisionsController < ApplicationController
  before_filter :require_user
  before_filter :get_rbuilder

  access_control do
    allow :admin
  end

  def index
    @subdivisions = Subdivision.all.sort
  end

  def show
    @subdivision = Subdivision.find(params[:id])
  end

  def new
    @subdivision = Subdivision.new
  end

  def create
    @subdivision = Subdivision.new(params[:subdivision])
    if @subdivision.save
      flash[:notice] = "Successfully created subdivision."
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @subdivision = Subdivision.find(params[:id])
  end

  def update
    @subdivision = Subdivision.find(params[:id])
    if @subdivision.update_attributes(params[:subdivision])
      flash[:notice] = "Successfully updated subdivision."
      redirect_to :action => 'index'
    else
      render :action => 'edit'
   end
  end

  def destroy
    @subdivision = Subdivision.find(params[:id])
    @subdivision.destroy
    flash[:notice] = "Successfully destroyed subdivision."
    redirect_to :action => 'index'
  end
end

