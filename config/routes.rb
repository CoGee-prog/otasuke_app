Rails.application.routes.draw do
  root 'static_pages#home'
  get 'no_event' => 'static_pages#event'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users, except: :show
  resources :account_activations, only:[:edit]
  resources :password_resets, only:[:new, :create, :edit, :update]
  resources :teams do
    member do
      get 'list'
      post 'switch' 
      get 'detail_schedule'
    end
    collection do
      get 'search_schedule'
    end
  end

  namespace :user do
    resources :member_requests, only: [:create, :destroy]
  end

  namespace :team do
    resources :member_requests, only: [:show, :destroy]
    resources :team_members, only: [:show, :create, :destroy]
  end

  resources :events, except: :index
  resources :event_entries, only: [:edit, :update]
  resources :game_requests, only:[:create, :destroy, :show]
  
end
