Rails.application.routes.draw do
  resources :edu_aids
  resources :edu_institutions
  ## User
  post '/users/login', to: 'users#login' 
  get '/users/logout', to: 'users#logout'
  post '/users', to: 'users#create'
  get '/users', to: 'users#index'
  post '/users/:id', to: 'users#update' 
  get '/users/delete/:id', to: 'users#delete' 
  get '/users/:id', to: 'users#show'

  devise_for :users
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
