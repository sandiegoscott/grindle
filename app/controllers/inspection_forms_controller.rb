class InspectionFormsController < ApplicationController
  before_filter :require_user
  
  access_control do
    allow :admin
    allow :inspector, :except => [:destroy]
    allow :builder, :areamanager, :to => [:index, :show]
  end
  
  def index
    @inspection_forms = InspectionForm.all
  end
  
  def show
    @inspection_form = InspectionForm.find(params[:id])
  end
  
  def new
    @inspection_form = InspectionForm.new
  end
  
  def create
    @inspection_form = InspectionForm.new(params[:inspection_form])
    if @inspection_form.save
      flash[:notice] = "Successfully created inspection form."
      redirect_to @inspection_form
    else
      render :action => 'new'
    end
  end
  
  def edit
    @builder = Rbuilder.find(params[:builder_id])
    @subs = Subdivision.find(:all)
    @cats = Category.find(:all, :order => 'abbrev')
    @ams = @builder.areamanagers.find(:all)
    @inspectors = Inspector.find(:all)
    @supers = @builder.superintendents.find(:all)
    @inspection_form = InspectionForm.find(params[:id])
  end
  
  def update
    @inspection_form = InspectionForm.find(params[:id])
    if @inspection_form.update_attributes(params[:inspection_form])
      flash[:notice] = "Successfully updated inspection form."
      redirect_to @inspection_form
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @inspection_form = InspectionForm.find(params[:id])
    @inspection_form.destroy
    flash[:notice] = "Successfully destroyed inspection form."
    redirect_to inspection_forms_url
  end
end
