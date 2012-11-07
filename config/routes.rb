# -*- encoding : utf-8 -*-
TrainApp::Application.routes.draw do
  match 'help' => 'application#help'

  match 'signup' => 'users#new'
  match 'signin' => 'sessions#new'
  match 'signout' => 'sessions#destroy'

  # password 的修改
  match 'password' => 'users#password', via: [:get]
  match 'password' => 'users#change_password', via: [:post]


  resources :users
  resources :posts, only: [:create]

  # follow/unfollow
  match 'follow' => 'relationships#create', via: [:post]
  match 'unfollow' => 'relationships#destory', via: [:delete]
  match 'followers' => 'relationships#followers', via: [:get]
  match 'followeds' => 'relationships#followeds', via: [:get]

  # 将用户登陆看做是创建 Session, 提供登陆页面(new), 登陆(create), 登出(destroy)
  resources :sessions, only: [:new, :create, :destroy]

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
  root :to => 'application#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
