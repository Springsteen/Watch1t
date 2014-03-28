Watch1t::Application.routes.draw do

  resources :episodes

  resources :seasons
  
  root :to => 'series#index'

  get 'users' => 'users#index' 
  get 'users/index' => 'users#index' 
  get 'users/register' => 'users#register' 
  match 'users/create', via: [:post]
  get 'users/edit' => 'users#edit' 
  match 'users/edit', via: [:get]
  match 'users/update', via: [:post]
  get 'users/user_panel' => 'users#user_panel' 
  get 'users/send_contact_mail' => 'users#send_contact_mail'
  match 'users/contacts', via: [:post] 
  match 'users/login', via: [:post]
  match 'users/logout', via: [:get]
  match 'users/destroy', via: [:get]
  match 'users/validate_email', via: [:post]
  match 'users/search_torents', via: [:get]

  get 'series' => 'series#index'
  match 'series/search',  via: [:post]
  
  
  match 'comments/show',  via: [:get] 
  match 'comments/post',  via: [:post]
  match 'comments/edit',  via: [:post]
  match 'comments/delete',  via: [:post]
  
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
