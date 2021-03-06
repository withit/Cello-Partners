ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  map.root :controller => 'home'
  map.resources :user_sessions
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.resources :users, :collection => {:search => :get}
  map.resource :flash
  map.resource :profile
  map.resources :quotes, :collection => {:search => :get},:has_many => :orders, :shallow => true
  map.resources :roles, :has_one => :grants
  map.resources :articles, :has_many => :documents
  map.resources :templates, :has_many => :articles
  map.resources :prices, :collection => {:upload => :post}
  map.resources :reels, :collection => {:upload => :post}
  map.resources :settings
  map.resources :password_resets
  map.resource :rep
  map.resources :grants
  map.resources :non_standard_quotes
  map.resources :addresses
  map.resources :pricing_group_names
  map.resources :pricing_groups
  map.resources :organisations do |org|
    org.resources :quotes, :collection => {:search => :get}, :has_many => :orders
    org.resources :addresses
    org.resources :non_standard_quotes
  end
  map.javascripts '/javascripts/:action.js', :controller => 'javascripts'
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"
  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
