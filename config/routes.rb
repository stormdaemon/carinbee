Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  root "pages#home"
  
  # Vehicles routes
  resources :vehicles do
    collection do
      get :my_vehicles
    end
    resources :rentals, except: [:index]
  end
  
  # Rentals routes
  resources :rentals, only: [:index, :show, :edit, :update, :destroy] do
    member do
      patch :confirm
      patch :refuse
      patch :complete
      patch :cancel
    end
    resources :reviews, except: [:index, :show]
  end
  
  # Reviews routes
  resources :reviews, only: [:index, :show]
  
  # Users routes
  resources :users, only: [:show, :edit, :update]
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
end
