Rails.application.routes.draw do
  resources :users do
    resources :medications, param: :name, only: [:index, :show, :create, :new, :edit, :destroy, :update]
  end
    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  root 'welcome#index'
  get 'welcome/index', to: 'welcome#index', as: 'welcome'
  get '/logout', to: 'sessions#logout', as: 'logout'
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'
end
