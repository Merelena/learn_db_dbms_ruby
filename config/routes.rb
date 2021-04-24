Rails.application.routes.draw do
  ## User
  post '/users/login', to: 'users#login' 
  get '/users/logout', to: 'users#logout'
  post '/users', to: 'users#create'
  get '/users', to: 'users#index'
  post '/users/:id', to: 'users#update' 
  get '/users/delete/:id', to: 'users#delete' 
  get '/users/:id', to: 'users#show'

  ## Edu institution
  post '/edu_institutions', to: 'edu_institutions#create'
  get '/edu_institutions', to: 'users#show'
  post '/edu_institutions/:id', to: 'users#update' 
  get '/users/delete/:id', to: 'users#delete' 
  devise_for :users
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
