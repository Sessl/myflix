Myflix::Application.routes.draw do
  
  #root to: 'videos#home'

  get 'ui(/:action)', controller: 'ui'
  get 'home(/:action)', controller: 'videos'

  resources :videos, except: [:destroy]
  resources :categories, except: [:destroy]
end
