class FinalInspectionsController < ApplicationController
  before_filter :require_user
  before_filter :require_rbuilder

  access_control do
    allow :admin
    allow :inspector, :except => [:destroy]
    allow :builder, :to => [:index, :show]
    allow :areamanager, :to => [:index, :show]
  end

  def index
    Rails.logger.info ">>>>>@rbuilder=#{@rbuilder.inspect}"
    @search = @rbuilder.final_inspections.search(params[:search])
    @final_inspections = @search.paginate(:per_page => 20, :page => params[:page], :order => "idate desc")
    @title = "#{@rbuilder.full_name} : #{@final_inspections.size} Final Inspections"
  end

  def show
    @final_inspection = FinalInspection.find(params[:id])
    check_dr_horton
    @inspector = @final_inspection.inspector
    make_contact_information(@inspector)
    @title = "#{@rbuilder.full_name} : #{@final_inspection.address} (#{@final_inspection.status})"
    respond_to do |format|
      format.html
      format.pdf do
        pdf = FinalInspectionPdf.new(@final_inspection, @inspector, @group_name, @rbuilder, @office, @mobile, @fax)
        send_data pdf.render, :filename => params[:id]+".pdf", :type => "application/pdf", :disposition => "inline"
      end
    end

  end

  def new
    city = @rbuilder.default_city || "San Antonio"
    @final_inspection = @rbuilder.final_inspections.build(:city => city, :dr_horton => false)
    make_choices
    set_title
  end

  def new_all_subs
    @subs = Subdivision.find(:all).sort   # list all subdivisions
    new                                   # then set up and render 'new'
    render :new
  end

  def create
    @final_inspection = FinalInspection.new(params[:final_inspection])
    @final_inspection.rbuilder_id = @rbuilder.id
    @final_inspection.dr_horton = false
    if @final_inspection.save
      flash[:notice] = "Successfully created final inspection."
      redirect_to final_inspection_path(@final_inspection)
    else
      make_choices
      render :action => 'new'
    end
  end

  def edit
    @final_inspection = FinalInspection.find(params[:id])
    check_dr_horton
    make_choices
    @title = "#{@rbuilder.full_name} : #{@final_inspection.address} (#{@final_inspection.status})"
  end

  def update
    @final_inspection = FinalInspection.find(params[:id])
    check_dr_horton
    if @final_inspection.update_attributes(params[:final_inspection])
      redirect_to(@final_inspection, :notice => 'Successfully updated final inspection.')
    else
      make_choices
      render :action => 'edit'
    end
  end

  def destroy
    @final_inspection = @rbuilder.final_inspections.find(params[:id])
    @final_inspection.destroy
    flash[:notice] = "Successfully destroyed final inspection."
    redirect_to :action => 'index'
  end

  def reassign
    # reassign random dates within the last year to Demo final inspections
    final_inspections = @rbuilder.final_inspections.find(:all)
    final_inspections.each do |final_inspection|
      days = rand(360)
      final_inspection.update_attribute(:idate, Date.today - days.days)
    end
    redirect_to final_inspections_path
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

  def set_title
    if @final_inspection.is_drhorton?
      @title = "#{@rbuilder.full_name} : New Orientation and Pre-Occupancy Punchlist"
    else
      @title = "#{@rbuilder.full_name} : New Final Inspection"
    end
  end

  def check_dr_horton
    if @final_inspection.is_drhorton? && !@rbuilder.is_drhorton?
      @final_inspection.update_attribute(:dr_horton, false)
    end
  end

end

