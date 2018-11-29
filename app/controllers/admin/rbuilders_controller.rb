class Admin::RbuildersController < ApplicationController
  before_filter :require_user
  before_filter :get_rbuilder

  access_control do
    allow :admin
    allow :inspector, :only => [:index, :show]
  end

  def index
    @rbuilders = Rbuilder.find(:all, :order => 'username asc')
  end

  def show
    @rbuilder = Rbuilder.find(params[:id])
    @superintendents = @rbuilder.superintendents.find(:all, :order => 'username asc')
    @areamanagers = @rbuilder.areamanagers.find(:all, :order => "username asc")
    if current_user.is_admin?
      @fninspections = @rbuilder.final_inspections.find(:all, :order => 'idate asc')
      @fminspections = @rbuilder.frame_inspections.find(:all, :order => 'idate asc')
    elsif current_user.is_inspector?
      @fninspections = @rbuilder.final_inspections.find(:all, :order => 'idate asc', :conditions => ["inspector_id = ?", current_user.id])
      @fminspections = @rbuilder.frame_inspections.find(:all, :order => 'idate asc', :conditions => ["inspector_id = ?", current_user.id])
    elsif current_user.is_superintendent?
      @fninspections = @rbuilder.final_inspections.find(:all, :order => 'idate asc', :conditions => ["superintendent_id = ?", current_user.id])
      @fminspections = @rbuilder.frame_inspections.find(:all, :order => 'idate asc', :conditions => ["superintendent_id = ?", current_user.id])
    elsif current_user.is_areamanager?
      @fninspections = @rbuilder.final_inspections.find(:all, :order => 'idate asc', :conditions => ["areamanger_id = ?", current_user.id])
      @fminspections = @rbuilder.frame_inspections.find(:all, :order => 'idate asc', :conditions => ["areamanger_id = ?", current_user.id])
    end
  end

  def new
    @rbuilder = Rbuilder.new
  end

  def create
    @rbuilder = Rbuilder.new(params[:rbuilder])
    @rbuilder.has_role!('builder')
    if @rbuilder.save_without_session_maintenance
      # make None superintendent and area manager
      @super = Superintendent.new(
        {:username => (@rbuilder.username+'-super'), :first_name => 'None',
         :last_name => '', :password => "nopassword", :password_confirmation => "nopassword",
         :email => (@rbuilder.username+'-super@none.com'), :rbuilder_id => @rbuilder.id, :inactive => false})
      flag = @super.save
      @areamanager = Areamanager.new(
        {:username => (@rbuilder.username+'-am'), :first_name => 'None',
         :last_name => '', :password => "nopassword", :password_confirmation => "nopassword",
         :email => (@rbuilder.username+'-am@none.com'), :rbuilder_id => @rbuilder.id, :inactive => false})
      flag = @areamanager.save
      flash[:notice] = "Successfully created rbuilder."
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @rbuilder = Rbuilder.find(params[:id])
  end

  def update
    @rbuilder = Rbuilder.find(params[:id])
    if @rbuilder.update_attributes(params[:rbuilder])
      flash[:notice] = "Successfully updated rbuilder."
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    # destroyed builder can't continue to be the current builder, now can he?
    session[:rbuilder_id] = nil if session[:rbuilder_id] && session[:rbuilder_id] == @rbuilder.id.to_s

    @rbuilder = Rbuilder.find(params[:id])
    @rbuilder.destroy
    flash[:notice] = "Successfully destroyed rbuilder."
    redirect_to :action => 'index'
  end
end

