Rails.application.routes.draw do
  #devise_for :users
  
  # Public routes
  root "stands#index"
  get "/map", to: "stands#index", as: :map
  resources :stands, only: [:index, :show]
  
  # Claims
  resources :claims, only: [:new, :create]
  
  # Auth (simple session-based)
  get "/signin", to: "sessions#new", as: :new_user_session
  post "/signin", to: "sessions#create"
  get "/signout", to: "sessions#destroy", as: :destroy_user_session
  get "/signup", to: "registrations#new", as: :new_user_registration
  post "/signup", to: "registrations#create"
  
  # Password reset
  get "/password/reset", to: "password_resets#new", as: :new_password_reset
  post "/password/reset", to: "password_resets#create"
  get "/password/reset/:id/edit", to: "password_resets#edit", as: :edit_password_reset
  patch "/password/reset/:id", to: "password_resets#update"
  
  # Farmer routes
  namespace :farmer do
    get "/dashboard", to: "dashboard#show", as: :dashboard
    resources :stands, only: [:new, :create, :edit, :update]
  end
  
  # Admin routes
  namespace :admin do
    get "/dashboard", to: "dashboard#show", as: :dashboard
    resources :stands do
      collection do
        get :import
        post :import_csv
      end
    end
    resources :claims, only: [:index] do
      member do
        post :approve
        post :reject
      end
    end
  end
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
