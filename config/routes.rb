Rails.application.routes.draw do
  get 'days/index'
  resources :users do
    resources :dashboard, only: [:index], as: 'dashboard'
    resources :medications, param: :name, only: [:index, :show, :create, :new, :edit, :destroy, :update] do
      resources :medication_schedules, only: [:create, :destroy, :edit, :update, :new, :index] do
        post :take_med, on: :member
        post :untake_med, on: :member
      end
      post :new_pickup, on: :collection, param: :date
    end
    resources :days, only: [:index]
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
  post '/public_medications/decrement', to: 'public_medications#decrement'
  post '/public_medications/increment', to: 'public_medications#increment'
  get '/users/:user_id/today', to: 'medication_schedules#get_current_day_schedules', as: 'today'
  get '/users/:user_id/medications/:medication_name/get_medication_schedules/:day_of_week', to: 'medication_schedules#get_day_schedules', as: 'get-day-schedule'
  get '/users/:user_id/day_history/:date_needed', to: 'days#get_history_day_schedules', as: 'get-day-history'
  get '/OneSignalSDKWorker.js', to: 'service_workers#onesignal_sdk_worker'
end
