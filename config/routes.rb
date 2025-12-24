Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Partner onboarding multi-step wizard
  resources :partner_onboarding, only: [:new, :show, :update] do
    member do
      get :complete
    end
  end
  resource :founder_onboarding, controller: "founder_onboarding", only: [:new, :show, :update]
  get "mentor_onboarding", to: "mentor_onboarding#show", as: :mentor_onboarding
  get "mentor_onboarding/new", to: "mentor_onboarding#new", as: :new_mentor_onboarding
  put "mentor_onboarding", to: "mentor_onboarding#update"
  missing_font = lambda do |_env|
    [ 204, { "Content-Type" => "font/woff2", "Cache-Control" => "public, max-age=86400" }, [] ]
  end
  missing_favicon = lambda do |_env|
    [ 204, { "Content-Type" => "image/x-icon", "Cache-Control" => "public, max-age=86400" }, [] ]
  end

  get "/favicon.ico", to: missing_favicon
  get "/assets/fonts/gotham/*font", to: missing_font

  get "onboarding/check_email", to: "onboarding_confirmations#check_email", as: :onboarding_check_email
  post "onboarding/resend_confirmation", to: "onboarding_confirmations#resend", as: :onboarding_resend_confirmation

  devise_for :users, controllers: { registrations: "registrations", omniauth_callbacks: "users/omniauth_callbacks", passwords: "users/passwords", confirmations: "users/confirmations" }
  devise_scope :user do
    get "mentors/sign_up", to: "registrations#new", as: :new_mentor_registration, defaults: { role: "mentor" }
    post "mentors", to: "registrations#create", as: :mentor_registration, defaults: { role: "mentor" }
    get "founders/sign_up", to: "registrations#new", as: :new_founder_registration, defaults: { role: "founder" }
    post "founders", to: "registrations#create", as: :founder_registration, defaults: { role: "founder" }
    get "partners/sign_up", to: "registrations#new", as: :new_partner_registration, defaults: { role: "partner" }
    post "partners", to: "registrations#create", as: :partner_registration, defaults: { role: "partner" }
    post "sign_in", to: "sessions#create"
    delete "sign_out", to: "sessions#destroy"
  end

  # ActiveStorage routes
  mount ActiveStorage::Engine => "/rails/active_storage"
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post "sign_in", to: "sessions#create"
        delete "sign_out", to: "sessions#destroy"
        post "sign_up", to: "registrations#create"
      end
      resource(:me, controller: "profiles", only: %i[show])
      resources(:hero_slides, only: %i[index])
      resources(:partners, only: %i[index])
      resources(:testimonials, only: %i[index])
      resources(:programs, param: :slug, only: %i[index show])
      resources(:resources, only: %i[index])
      resources(:startup_profiles, only: %i[index])
      resources(:mentor_profiles, only: %i[index])
      resources(:mentorship_requests, only: %i[index create]) do
        patch :respond, on: :member
      end
      get "matches", to: "matches#index"
      post "onboarding/founder", to: "onboarding#founder"
      post "onboarding/mentor", to: "onboarding#mentor"
    end
  end

  # mount RailsAdmin::Engine => "/admin", as: "rails_admin" # Removed for ActiveAdmin migration
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"
  get 'about', to: 'pages#about', as: :about
  get "programs", to: "pages#programs" # Marketing page (commented out)
  get "programs/:slug", to: "pages#program_detail", as: :program_detail # Marketing page (commented out)
  get "resources", to: "pages#resources" # Marketing page (commented out)
  get "resources/category/:category", to: "pages#resources", as: :resources_category, constraints: { category: /blogs|knowledge-hub|opportunities|events/ } # Marketing page (commented out)
  get "resources/:slug", to: "pages#resource_detail", as: :resource_detail # Marketing page (commented out)
  get "startups", to: "pages#startup_directory" # Marketing page (commented out)
  get "startups/:id/profile", to: "pages#startup_profile", as: :public_startup_profile # Marketing page (commented out)
  get "mentors", to: "pages#mentor_directory" # Marketing page (commented out)
  get "pricing", to: "pages#pricing" # Marketing page (commented out)
  get "contact", to: "pages#contact" # Marketing page (commented out)

  get "dashboard", to: redirect("/founder"), constraints: lambda { |req| req.session[:user_id].present? }
  get "profile", to: redirect("/founder/account"), constraints: lambda { |req| req.session[:user_id].present? }
  get "mentor_dashboard", to: redirect("/mentor"), constraints: lambda { |req| req.session[:user_id].present? }
  get "mentor_profile", to: redirect("/mentor/profile"), constraints: lambda { |req| req.session[:user_id].present? }
  # Use Devise pages as the canonical auth UI.
  get "login", to: redirect("/users/sign_in")
  get "signup", to: redirect("/users/sign_up")
  get "mentors_signup", to: redirect("/mentors/sign_up")
  get "partners_signup", to: redirect("/partners/sign_up")
  get "partners_signup", to: redirect("/partners/sign_up")

  namespace :founder do
    root to: "dashboard#show"

    resource(:startup_profile, only: %i[show edit update])
    resource(:progress, only: %i[show])
    resources(:milestones)
    resources(:monthly_metrics, only: %i[new create edit update index])
    resources(:baseline_plans)

    get "mentorship", to: "mentorship#index"
    resources(:mentors, only: %i[index show])
    resources(:mentorship_requests, only: %i[index show new create])
    resources(:sessions, only: %i[index show new create])

    resources(:conversations, path: "messages", only: %i[index show]) do
      resources(:messages, only: %i[create])
    end

    resources(:resources, only: %i[index show]) do
      member do
        post :bookmark
        post :rate
        get  :download
      end
    end

    resources(:opportunities, only: %i[index show]) do
      member { get :apply }
      resources(:submissions, controller: "opportunity_submissions", only: %i[create])
    end

    get "community", to: "community#index"
    resources(:connections, only: %i[create])
    resources(:peer_messages, only: %i[create])

    resource(:account, controller: "account", only: %i[show edit update])
    resource(:subscription, only: %i[show new create])

    get "support", to: "support#show"
    post "support", to: "support#create"
  end

  namespace :mentor, module: "mentor_portal" do
    root to: "dashboard#show"

    resources(:mentorship_requests, only: %i[index show]) do
      member do
        patch :accept
        patch :decline
        patch :reschedule
      end
    end

    resources(:conversations, path: "messages", only: %i[index show]) do
      resources(:messages, only: %i[create])
    end

    get "schedule", to: "schedule#show"
    resources(:sessions, only: %i[index show]) do
      member do
        get :join
        get :add_to_calendar
      end
    end

    resources(:startups, only: %i[index show]) do
      get :progress, to: "startup_progress#show"
    end

    resource(:profile, controller: "profiles", only: %i[show edit update])
    resource(:settings, only: %i[show update])
    get "support", to: "support#show"
  end

  get "auth/google_oauth2/callback", to: "google_calendar#callback"
  get "auth/google_oauth2", as: "google_oauth2_auth", to: "google_calendar#connect"

  # Defines the root path route ("/")
  # root "posts#index"
end
