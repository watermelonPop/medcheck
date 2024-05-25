Rails.application.routes.draw do
  get 'sessions/logout'
  get 'sessions/omniauth'
  get 'users/show'
  root 'welcome#index'
  get 'welcome/index', to: 'welcome#index', as: 'welcome'

  get '/users/:id', to: 'users#show', as: 'user'

  get '/logout', to: 'sessions#logout', as: 'logout'
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
