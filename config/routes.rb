JacobJoins::Application.routes.draw do
  root :to => 'high_voltage/pages#show', :id => "index"
  
  resources :recipes, :only => [:index, :show, :create, :update]
  resources :users, :only => [:index, :show, :create, :update]
  resources :country_specific_informations, :only => [:create, :update]
end
