Rails.application.routes.draw do
  root 'static_pages#home'
  get 'no_event', to: 'static_pages#event'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
	get 'auth/:provider/callback', to: 'sessions#create_google'
  get 'auth/failure', to: redirect('/')
  delete '/logout', to: 'sessions#destroy'
  resources :users, except: :show
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :teams do
    member do
			patch 'destroy_image'
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
    resources :team_members, only: [:show, :create, :edit, :update, :destroy] do
			member do
      get 'edit_order'
      patch 'update_order' 
    	end
		end
  end

  resources :events, except: :index
  resources :event_entries, only: [:edit, :update]
  resources :game_requests, only: [:create, :destroy, :show]
	resources :event_comments, only: [:create, :destroy]
end
