require File.dirname(__FILE__) + '/../spec_helper'
 
describe SuperintendentsController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => Superintendent.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    Superintendent.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    Superintendent.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(superintendent_url(assigns[:superintendent]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => Superintendent.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    Superintendent.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Superintendent.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    Superintendent.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Superintendent.first
    response.should redirect_to(superintendent_url(assigns[:superintendent]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    superintendent = Superintendent.first
    delete :destroy, :id => superintendent
    response.should redirect_to(superintendents_url)
    Superintendent.exists?(superintendent.id).should be_false
  end
end
