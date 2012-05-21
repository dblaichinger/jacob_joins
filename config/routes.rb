JacobJoins::Application.routes.draw do
  root :to => 'pages#show', :id => "index"

  get "/pages/preview" => 'pages#show', :as => :page, :format => false, :id => "preview"
  get "/pages/drafts_saved" => 'pages#show', :as => :page, :format => false, :id => "drafts_saved"
  
  get '/recipes/last', :to => 'recipes#last'
  post '/users/find_user', :to => 'users#find_user'

  match 'recipes/sync_wizard' => 'recipes#sync_wizard', :via => [:post, :put]
  match 'recipes/upload_step_image' => 'recipes#upload_step_image', :via => :post
  match 'recipes/delete_step_image/:step_id' => 'recipes#delete_step_image', :via => :delete, :as => 'recipes_delete_step_image'
  match 'recipes/upload_image' => 'recipes#upload_image', :via => :post
  match 'recipes/delete_image/:image_id' => 'recipes#delete_image', :via => :delete, :as => 'recipes_delete_image'
  match '/recipes/search' => 'recipes#search', :via => [:get, :post]

  match 'country_specific_informations/sync_wizard' => 'country_specific_informations#sync_wizard', :via => [:post, :put]
  match 'users/sync_wizard' => 'users#sync_wizard', :via => [:post, :put]

  get '/ingredients/names', :to => 'ingredients#names'
  
  resources :recipes, :only => [:index, :show, :update]
  resources :users, :only => [:index, :show, :update]
  resources :country_specific_informations, :only => [:index, :show, :update]
end
