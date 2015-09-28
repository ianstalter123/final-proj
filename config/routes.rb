Rails.application.routes.draw do
  root to: 'statics#index'
  resources :users

    get '/lists/:asin/:api', to: "lists#info"
  resources :lists, only: [:index, :show, :create, :update, :destroy]


  get '/calls/:title', to: "calls#results"
  get '/:id/calls', to: "calls#charts"
  resources :calls, only: [:index, :create, :update, :destroy]


  get 'login', to: "sessions#login", as: "login"
  post 'login', to: "sessions#attempt_login"

  get '/signup', to: "sessions#signup", as: 'signup'
  post '/signup', to: "sessions#create"

  delete 'logout', to: "sessions#logout", as: "logout"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  #    root GET    /                         statics#index
  #     users GET    /users(.:format)          users#index
  #           POST   /users(.:format)          users#create
  #  new_user GET    /users/new(.:format)      users#new
  # edit_user GET    /users/:id/edit(.:format) users#edit
  #      user GET    /users/:id(.:format)      users#show
  #           PATCH  /users/:id(.:format)      users#update
  #           PUT    /users/:id(.:format)      users#update
  #           DELETE /users/:id(.:format)      users#destroy
  #     lists GET    /lists(.:format)          lists#index
  #           POST   /lists(.:format)          lists#create
  #      list GET    /lists/:id(.:format)      lists#show
  #           PATCH  /lists/:id(.:format)      lists#update
  #           PUT    /lists/:id(.:format)      lists#update
  #           DELETE /lists/:id(.:format)      lists#destroy
  #     login GET    /login(.:format)          sessions#login
  #           POST   /login(.:format)          sessions#attempt_login
  #    signup GET    /signup(.:format)         sessions#signup
  #           POST   /signup(.:format)         sessions#create
  #    logout DELETE /logout(.:format)         sessions#logout
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
