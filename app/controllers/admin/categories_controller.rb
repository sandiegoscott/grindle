class Admin::CategoriesController < ApplicationController
  before_filter :require_user
  before_filter :require_rbuilder

  access_control do
    allow :admin
  end

  def index
    @categories = Category.all.sort
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new(:ctype => "Trade")
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = "Successfully created category."
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = "Successfully updated category."
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:notice] = "Successfully destroyed category."
    redirect_to :action => 'index'
  end
end

