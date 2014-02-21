Myflix::Application.routes.draw do
  
  root to: 'videos#index'

  get 'ui(/:action)', controller: 'ui'

  resources :videos, except: [:destroy]
  resources :categories, except: [:destroy]
end
