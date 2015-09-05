Rails.application.routes.draw do
  get 'map/index'
  
  get '/auth/:provider/callback',    to: 'users#create',       as: :auth_callback
  get '/auth/failure',               to: 'users#auth_failure', as: :auth_failure
  
  resources :locations
  root to: 'static_pages#home'
  get 'signup', to: 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts
  resources :relationships, only: [:create, :destroy]
end
