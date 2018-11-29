class FrameInspectionsController < ApplicationController
  before_filter :require_user
  before_filter :require_rbuilder

  access_control do
    allow :admin
    allow :inspector, :except => [:destroy]
    allow :builder, :to => [:index, :show]
    allow :areamanager, :to => [:index, :show]
  end

  def index
    @search = @rbuilder.frame_inspections.search(params[:search])
    @frame_inspections = @search.paginate(:per_page => 20, :page => params[:page], :order => "idate desc")
    @title = "#{@rbuilder.full_name} : #{@frame_inspections.size} frame Inspections"
  end

  def show
    @frame_inspection = FrameInspection.find(params[:id])
    @inspector = @frame_inspection.inspector
    make_contact_information(@inspector)
    @title = "#{@rbuilder.full_name} : #{@frame_inspection.address} (#{@frame_inspection.status})"
    respond_to do |format|
      format.html
      format.pdf do
        pdf = FrameInspectionPdf.new(@frame_inspection, @inspector, @group_name, @rbuilder, @office, @mobile, @fax)
        send_data pdf.render, :filename => params[:id]+".pdf", :type => "application/pdf", :disposition => "inline"
      end
    end
  end

  def new
    city = @rbuilder.default_city.nil? ? "San Antonio" : @rbuilder.default_city
    @frame_inspection = @rbuilder.frame_inspections.build(:city => city)
    make_choices
    @title = "#{@rbuilder.full_name} : New Frame Inspection"
  end

  def new_all_subs
    @subs = Subdivision.find(:all).sort   # list all subdivisions
    new                                   # then set up and render 'new'
    render :new
  end

  def create
    @frame_inspection = FrameInspection.new(params[:frame_inspection])
    @frame_inspection.rbuilder_id = @rbuilder.id
    if @frame_inspection.save
      flash[:notice] = "Successfully created frame inspection."
      @title = "#{@rbuilder.full_name} : #{@frame_inspection.address} (#{@frame_inspection.status})"
      render :show  # redirect_to :action => 'index'
    else
      make_choices
      render :action => 'new'
    end
  end

  def edit
    @frame_inspection = FrameInspection.find(params[:id])
    make_choices
    @title = "#{@rbuilder.full_name} : #{@frame_inspection.address} (#{@frame_inspection.status})"
  end

  def update
    @frame_inspection = FrameInspection.find(params[:id])
    if @frame_inspection.update_attributes(params[:frame_inspection])
      redirect_to(@frame_inspection, :notice => 'Successfully updated frame inspection.')
    else
      make_choices
      render :action => 'edit'
    end
  end

  def destroy
    @frame_inspection = @rbuilder.frame_inspections.find(params[:id])
    @frame_inspection.destroy
    flash[:notice] = "Successfully destroyed frame inspection."
    redirect_to :action => 'index'
  end

  def reassign
    # reassign random dates within the last year to Demo frame inspections
    frame_inspections = @rbuilder.frame_inspections.find(:all)
    frame_inspections.each do |frame_inspection|
      days = rand(360)
      frame_inspection.update_attribute(:idate, Date.today - days.days)
    end
    redirect_to frame_inspections_path
  end
  
  private

  def make_choices
    @subs = @rbuilder.subdivisions.sort.uniq if @subs.blank?
    @subs = Subdivision.all.sort.uniq if @subs.blank?
    @cats = Category.find(:all, :order => 'abbrev')
    @ams = @rbuilder.areamanagers.find(:all)
    @inspectors = Inspector.find(:all)
    @supers = @rbuilder.superintendents.find(:all)
  end

end

