Myflix::Application.routes.draw do
  
  root to: 'videos#front'

  get 'ui(/:action)', controller: 'ui'
# get 'home(/:action)', controller: 'videos'
  get 'home', to: 'videos#index', as: 'home'
  get 'register', to: 'users#new', as: 'register'
  get 'register/:token', to: "users#new_with_invitation_token", as: 'register_with_token'
  get 'sign_in', to: 'sessions#new', as: 'sign_in'
  post 'sign_in', to: 'sessions#create', as: 'sessions'
  get 'sign_out', to: 'sessions#destroy', as: 'destroy'
  get 'people', to: 'relationships#index', as: 'people'
  resources :relationships, only: [:destroy, :create]

  resources :videos, except: [:destroy, :index] do
  	collection do
  		get 'search', to: 'videos#search'
      get 'advanced_search', to: "videos#advanced_search", as: :advanced_search
  	end

    resources :reviews, only: [:create]
  end

  get 'my_queue', to: 'queue_items#index', as: 'my_queue'
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  resources :categories, except: [:destroy]
  resources :users, only: [:create] 
  resources :users, only: [:show]

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'pages#expired_token'

  resources :invitations, only: [:new, :create]

  mount StripeEvent::Engine, at: '/stripe_events'

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end
end
