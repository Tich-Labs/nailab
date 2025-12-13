Rails.application.routes.draw do
  resources :mentor_applications, only: [:new, :create]
  get "/resources", to: "resources#index"
  resources :programs
  mount_avo
  # ✅ Home page
  root "home#index"

  # ✅ Devise for users (with OmniAuth support)
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # Allow GET for sign_out (fallback for links without proper method)
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  # Devise for admin users (for Avo)
  devise_for :admin_users

  # ✅ Core resources
  resources :startups, only: [:index, :show]
  resources :mentors
  resources :events
  resources :blog_posts
  resources :opportunities
  resources :template_guides

  # ✅ Mentorship flow
  get 'mentorship/select-type', to: 'mentorship#select_type'
  get 'mentorship_requests/new_one_time', to: 'mentorship_requests#new_one_time'
  get 'mentorship_requests/new_ongoing', to: 'mentorship_requests#new_ongoing'
  post 'mentorship_requests', to: 'mentorship_requests#create'

  # ✅ User dashboard
  get 'dashboard', to: 'dashboard#show'

  # 🩺 Health check
  get "up", to: "rails/health#show", as: :rails_health_check

  # 📦 Future: PWA support
  # get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker

  # 🧪 Optional: Sidekiq Web UI
  # require 'sidekiq/web'
  # authenticate :admin_user do
  #   mount Sidekiq::Web => '/sidekiq'
  # end
end
