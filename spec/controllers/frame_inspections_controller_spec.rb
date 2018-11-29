require File.dirname(__FILE__) + '/../spec_helper'
 
describe FrameInspectionsController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => FrameInspection.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    FrameInspection.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    FrameInspection.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(frame_inspection_url(assigns[:frame_inspection]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => FrameInspection.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    FrameInspection.any_instance.stubs(:valid?).returns(false)
    put :update, :id => FrameInspection.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    FrameInspection.any_instance.stubs(:valid?).returns(true)
    put :update, :id => FrameInspection.first
    response.should redirect_to(frame_inspection_url(assigns[:frame_inspection]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    frame_inspection = FrameInspection.first
    delete :destroy, :id => frame_inspection
    response.should redirect_to(frame_inspections_url)
    FrameInspection.exists?(frame_inspection.id).should be_false
  end
end
