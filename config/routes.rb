Rails.application.routes.draw do
  resources :day_takens
  get 'sessions/logout'
  get 'sessions/omniauth'
  get 'users/show'
  root 'welcome#index'
  get 'welcome/index', to: 'welcome#index', as: 'welcome'

  get '/users/:id', to: 'users#show', as: 'user'
  get 'users/:user_id/history/get_date/:date_needed', to: 'histories#get_history_day_schedules', as: 'get-day-history'

  resources :users do
    resources :dashboard, only: [:index], as: 'dashboard'
    resources :medications, param: :id, only: [:index, :show, :create, :new, :edit, :destroy, :update] do
      resources :medication_schedules, only: [:create, :destroy, :edit, :update, :new, :index] do
      end
    end
    resources :histories, only: [:index, :new, :show, :create, :edit], as: 'histories' do
    end
    resources :day_takens, only: [:create, :edit, :update, :new, :index]
  end

  get '/logout', to: 'sessions#logout', as: 'logout'
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'
  get '/auth/failure', to: 'sessions#failure'

  get '/users/:user_id/medications/:medication_id/medication_schedules/:id/set_taken', to: 'dashboard#set_taken', as: :set_taken
  get '/users/:user_id/medications/:medication_id/get_medication_schedules/:day_of_week', to: 'medication_schedules#get_day_schedules', as: 'get-day-schedule'
  get '/users/:user_id/get_today_schedules', to: 'medication_schedules#get_today_schedules', as: 'get-today-schedule'
  get '/users/:user_id/medications/:medication_id/new_pickup/:date/:amount', to: 'medications#new_pickup', as: 'new-pickup'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
