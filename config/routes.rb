ActionController::Routing::Routes.draw do |map|

  #map.root :controller => 'user_sessions', :action => 'new'
  map.root :controller => 'overview', :action => 'index'

  #map.inspection "inspection", :controller => "inspections", :action => "index"
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

  map.resources :overview

  map.resources :final_inspections, :collection => { :new_all_subs => :get }
  map.resources :frame_inspections, :collection => { :new_all_subs => :get }
  map.resources :punchlists,        :collection => { :new_all_subs => :get }

  # reassign dates to Demo inspections
  map.reassign_final '/reassign_final', :controller => 'final_inspections', :action => 'reassign'
  map.reassign_frame '/reassign_frame', :controller => 'frame_inspections', :action => 'reassign'

  # admin
  map.resources :inspectors,      :path_prefix => 'admin', :controller => 'admin/inspectors'
  map.resources :rbuilders,       :path_prefix => 'admin', :controller => 'admin/rbuilders'
  map.resources :areamanagers,    :path_prefix => 'admin', :controller => 'admin/areamanagers'
  map.resources :superintendents, :path_prefix => 'admin', :controller => 'admin/superintendents'
  map.resources :subdivisions,    :path_prefix => 'admin', :controller => 'admin/subdivisions'
  map.resources :categories,      :path_prefix => 'admin', :controller => 'admin/categories'

  # authentication
  map.resources :user_sessions
  map.resources :users

  #map.resources :rbuilders, :has_many => [:inspection_forms, :final_inspections, :frame_inspections, :areamanagers, :superintendents]

  #map.resources :areamanagers, :has_many => [:final_inspections, :frame_inspections, :inspection_forms]

  #map.resources :inspectors, :has_many => [:final_inspections, :frame_inspections, :inspection_forms, :reinspections]

  #map.resources :superintendents, :has_many => [:final_inspections, :frame_inspections, :inspection_forms]

  #map.resources :final_inspections, :collection => { :new_all_subs => :get }
  #, :has_many => [:defects, :comments, :reinspections], :only => [:index, :show]
  #map.connect "/rbuilders/:rbuilder_id/final_inspection/new_all_subs",  :controller => "final_inspections", :action => "new_all_subs"
  #map.connect "/rbuilders/:rbuilder_id/final_inspections/:id/edit_all_subs", :controller => "final_inspections", :action => "edit_all_subs"

  #map.resources :frame_inspections#, :has_many => [:defects, :comments, :reinspections], :only => [:index, :show]
  #map.connect "/rbuilders/:rbuilder_id/frame_inspection/new_all_subs",  :controller => "frame_inspections", :action => "new_all_subs"
  #map.connect "/rbuilders/:rbuilder_id/frame_inspections/:id/edit_all_subs", :controller => "frame_inspections", :action => "edit_all_subs"

  #map.resources :subdivisions, :has_many => [:inspection_forms]

  map.resources :reports, :collection => { :units => :get, :subdivisions_chart => :get, :subdivisions => :get, :superintendent => :get, :areamanager => :get, :pdf => :get }

  map.resources :defects, :only => [:index, :show]

  map.resources :comments, :only => [:index, :show]

  map.resources :items, :only => [:index, :show]

  map.resources :inspection_forms, :has_many => [:defects, :comments, :reinspections]

  # non-resource
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

