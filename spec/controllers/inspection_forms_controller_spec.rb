require File.dirname(__FILE__) + '/../spec_helper'
 
describe InspectionFormsController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => InspectionForm.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    InspectionForm.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    InspectionForm.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(inspection_form_url(assigns[:inspection_form]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => InspectionForm.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    InspectionForm.any_instance.stubs(:valid?).returns(false)
    put :update, :id => InspectionForm.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    InspectionForm.any_instance.stubs(:valid?).returns(true)
    put :update, :id => InspectionForm.first
    response.should redirect_to(inspection_form_url(assigns[:inspection_form]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    inspection_form = InspectionForm.first
    delete :destroy, :id => inspection_form
    response.should redirect_to(inspection_forms_url)
    InspectionForm.exists?(inspection_form.id).should be_false
  end
end
