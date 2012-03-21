JacobJoins::Application.routes.draw do
  root :to => 'high_voltage/pages#show', :id => "index"
  
  get '/recipes/last', :to => 'recipes#last'
  post '/users/find_user', :to => 'users#find_user'

  match 'recipes/sync_wizard' => 'recipes#sync_wizard', :via => [:post, :put]
  match 'recipes/upload_step_image' => 'recipes#upload_step_image', :via => :post
  match 'recipes/delete_step_image/:step_id' => 'recipes#delete_step_image', :via => :delete, :as => 'recipes_delete_step_image'
  match 'recipes/upload_image' => 'recipes#upload_image', :via => :post
  match 'recipes/delete_image/:image_id' => 'recipes#delete_image', :via => :delete, :as => 'recipes_delete_image'

  match 'country_specific_informations/sync_wizard' => 'country_specific_informations#sync_wizard', :via => [:post, :put]
  
  resources :recipes, :only =>[:index, :show, :create, :update]
  resources :users, :only => [:index, :show, :create, :update]
  resources :country_specific_informations, :only => [:create, :update]
end
