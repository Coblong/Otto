Otto::Application.routes.draw do
  resources :users do
    resources :estate_agents
  end
  resources :estate_agents do
    resources :branches
    resources :agents
    resources :properties
  end
  resources :branches do
    resources :agents
    resources :properties
  end
  resources :agents do
    resources :properties
  end
  resources :properties do
    resources :estate_agents
    resources :branches
    resources :agents
  end
  resources :sessions, only: [:new, :create, :destroy]

  get "static_pages/home"
  
  root  'static_pages#home'
  match '/',                to: 'static_pages#home',      via: 'get'
  match '/signup',          to: 'users#new',              via: 'get'
  match '/signin',          to: 'sessions#new',           via: 'get'
  match '/quietsession',    to: 'sessions#quietly',       via: 'post'
  match '/signout',         to: 'sessions#destroy',       via: 'delete'
  match '/validate',        to: 'sessions#validate',      via: 'get'
  match '/external/property',to: 'properties#external',    via: 'get'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
