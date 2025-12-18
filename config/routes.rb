Rails.application.routes.draw do
  get 'founder_onboarding', to: 'founder_onboarding#show', as: :founder_onboarding
  put 'founder_onboarding', to: 'founder_onboarding#update'
  get 'mentor_onboarding', to: 'mentor_onboarding#show', as: :mentor_onboarding
  put 'mentor_onboarding', to: 'mentor_onboarding#update'
  missing_font = lambda do |_env|
    [204, { 'Content-Type' => 'font/woff2', 'Cache-Control' => 'public, max-age=86400' }, []]
  end
  missing_favicon = lambda do |_env|
    [204, { 'Content-Type' => 'image/x-icon', 'Cache-Control' => 'public, max-age=86400' }, []]
  end

  get '/favicon.ico', to: missing_favicon
  get '/assets/fonts/gotham/*font', to: missing_font

  devise_for :users, controllers: { registrations: 'registrations' }
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post 'sign_in', to: 'sessions#create'
        delete 'sign_out', to: 'sessions#destroy'
        post 'sign_up', to: 'registrations#create'
      end
      resource(:me, controller: 'profiles', only: %i[show])
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
      get 'matches', to: 'matches#index'
      post 'onboarding/founder', to: 'onboarding#founder'
      post 'onboarding/mentor', to: 'onboarding#mentor'
    end
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'programs', to: 'pages#programs'
  get 'programs/:slug', to: 'pages#program_detail', as: :program_detail
  get 'resources', to: 'pages#resources'
  get 'resources/category/:category', to: 'pages#resources', as: :resources_category, constraints: { category: /blogs|knowledge-hub|opportunities|events/ }
  get 'resources/:slug', to: 'pages#resource_detail', as: :resource_detail
  get 'startups', to: 'pages#startup_directory'
  get 'startups/:id/profile', to: 'pages#startup_profile', as: :public_startup_profile
  get 'mentors', to: 'pages#mentor_directory'
  get 'pricing', to: 'pages#pricing'
  get 'contact', to: 'pages#contact'

  get 'dashboard', to: redirect('/founder'), constraints: lambda { |req| req.session[:user_id].present? }
  get 'profile', to: redirect('/founder/account'), constraints: lambda { |req| req.session[:user_id].present? }
  # Use Devise pages as the canonical auth UI.
  get 'login', to: redirect('/users/sign_in')
  get 'signup', to: redirect('/users/sign_up')

  namespace :founder do
    root to: "dashboard#show"

    resource(:startup_profile, only: %i[show edit update])
    resource(:progress, only: %i[show])
    resources(:milestones)
    resources(:monthly_metrics, only: %i[new create edit update index])

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

  delete "/logout", to: "sessions#destroy"

  # Defines the root path route ("/")
  # root "posts#index"
end
