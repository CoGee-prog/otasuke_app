Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home'
  get '/signup', to:'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :account_activations, only:[:edit]
  resources :password_resets, only:[:new, :create, :edit, :update]
  resources :teams do
    member do
      get 'list'
      post 'switch' 
    end
  end

  namespace :user do
    resources :member_requests, only: [:create, :destroy]
  end

  namespace :team do
    resources :member_requests, only: [:show, :destroy]
    resources :team_members, only: [:show, :create, :destroy]
  end

end
