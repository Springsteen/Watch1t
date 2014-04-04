Watch1t::Application.routes.draw do

  root :to => 'series#index'

  get 'users' => 'users#index' 
  get 'users/index' => 'users#index' 
  get 'users/register' => 'users#register' 
  get 'users/edit' => 'users#edit' 
  get 'users/user_panel' => 'users#user_panel' 
  get 'users/send_contact_mail' => 'users#send_contact_mail'
  match 'users/create', via: [:post]
  match 'users/edit', via: [:get]
  get 'users/admin_edit_panel/:user_id' => 'users#admin_edit_panel'
  get 'users/admin_edit_panel' => 'users#choose_a_user' 
  match 'users/update', via: [:post]
  match 'users/admin_update', via: [:post]
  match 'users/contacts', via: [:post] 
  match 'users/login', via: [:post]
  match 'users/logout', via: [:get]
  match 'users/destroy', via: [:get]
  match 'users/validate_email', via: [:post]
  get 'users/search_torents' => 'users#search_torents'

  get 'series' => 'series#index'
  get 'series/index' => 'series#index'
  match 'series/search',  via: [:post]
  get 'series/:id' => 'series#show'
  match 'series/show',  via: [:get]
  get 'series/:id/update' => 'series#synch'

  get 'list_seasons' => 'seasons#list_all_seasons'
  match 'seasons/list_seasons', via: [:post]
  get 'seasons/:id' => 'seasons#show'
  match 'seasons/show',  via: [:get]
  # ADD EDIT PATH ONLY FOR ADMIN
  # ADD NEW SEASON PATH ONLY FOR ADMIN

  get 'list_episodes' => 'episodes#list_all_episodes'
  match 'episodes/list_episodes', via: [:post]
  get 'episodes/:id' => 'episodes#show'
  match 'episodes/show',  via: [:get]
  # ADD EDIT PATH ONLY FOR ADMIN
  # ADD NEW EPISODE PATH ONLY FOR ADMIN

  match 'comments/post',  via: [:post]
  match 'comments/edit',  via: [:post]
  get 'comments/edit_menu/:comment_id' => 'comments#edit_menu'
  match 'comments/delete',  via: [:get]
  get 'comments/delete/:comment_id' => 'comments#delete'
  
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
