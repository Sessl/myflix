Myflix::Application.routes.draw do
  
  root to: 'videos#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home(/:action)', controller: 'videos'

  resources :videos, except: [:destroy] do
  	collection do
  		get 'search', to: 'videos#search'
  	end
  end

  resources :categories, except: [:destroy]
end
