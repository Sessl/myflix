Myflix::Application.routes.draw do
  
  root to: 'videos#front'

  get 'ui(/:action)', controller: 'ui'
# get 'home(/:action)', controller: 'videos'
  get 'home', to: 'videos#index', as: 'home'
  get 'register', to: 'users#new', as: 'register'

  resources :videos, except: [:destroy, :index] do
  	collection do
  		get 'search', to: 'videos#search'
  	end
  end

  resources :categories, except: [:destroy]
  resources :users, only: [:create]
end
