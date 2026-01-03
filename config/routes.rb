Rails.application.routes.draw do
  get "partner_onboarding", to: "partner_onboarding#show", as: :partner_onboarding
  put "partner_onboarding", to: "partner_onboarding#update"
  get "founder_onboarding", to: "founder_onboarding#show", as: :founder_onboarding
  put "founder_onboarding", to: "founder_onboarding#update"
  patch "founder_onboarding/save_and_exit", to: "founder_onboarding#save_and_exit", as: :founder_onboarding_save_and_exit
  get "mentor_onboarding", to: "mentor_onboarding#show", as: :mentor_onboarding
  put "mentor_onboarding", to: "mentor_onboarding#update"
  patch "mentor_onboarding/save_and_exit", to: "mentor_onboarding#save_and_exit", as: :mentor_onboarding_save_and_exit
  missing_font = lambda do |_env|
    [ 204, { "Content-Type" => "font/woff2", "Cache-Control" => "public, max-age=86400" }, [] ]
  end
  missing_favicon = lambda do |_env|
    [ 204, { "Content-Type" => "image/x-icon", "Cache-Control" => "public, max-age=86400" }, [] ]
  end

  get "/favicon.ico", to: missing_favicon
  get "/assets/fonts/gotham/*font", to: missing_font

  devise_for :users, controllers: { registrations: "registrations", omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    get "mentors/sign_up", to: "registrations#new", as: :new_mentor_registration, defaults: { role: "mentor" }
    post "mentors", to: "registrations#create", as: :mentor_registration, defaults: { role: "mentor" }
    get "founders/sign_up", to: "registrations#new", as: :new_founder_registration, defaults: { role: "founder" }
    post "founders", to: "registrations#create", as: :founder_registration, defaults: { role: "founder" }
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
      # resources(:hero_slides, only: %i[index])
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

  # Block redundant RailsAdmin endpoints (these models are intentionally excluded from admin).
  match "/admin/user(/*path)", to: redirect("/admin"), via: :all
  match "/admin/user_profile(/*path)", to: redirect("/admin"), via: :all
  match "/admin/identity(/*path)", to: redirect("/admin"), via: :all
  match "/admin/notification(/*path)", to: redirect("/admin"), via: :all
  match "/admin/jwt_denylist(/*path)", to: redirect("/admin"), via: :all
  match "/admin/conversation(/*path)", to: redirect("/admin"), via: :all
  match "/admin/message(/*path)", to: redirect("/admin"), via: :all
  match "/admin/peer_message(/*path)", to: redirect("/admin"), via: :all
  match "/admin/opportunity(/*path)", to: redirect("/admin"), via: :all
  match "/admin/milestone(/*path)", to: redirect("/admin"), via: :all
  match "/admin/opportunity_submission(/*path)", to: redirect("/admin"), via: :all
  match "/admin/hero_slide(/*path)", to: redirect("/admin"), via: :all

  # Custom admin homepage editors and logo management — define before mounting RailsAdmin
  namespace :admin do
    resources :logos, only: %i[index new create update destroy]
    resources :testimonials, only: %i[index new create edit update destroy]
    # Friendly custom Focus Areas editor (override RailsAdmin path) - define before mounting RailsAdmin
    get "focus_area", to: "focus_areas#index", as: :focus_areas
    get "focus_area/new", to: "focus_areas#new", as: :new_focus_area
    post "focus_area", to: "focus_areas#create", as: :create_focus_area
    get "focus_area/:id/edit", to: "focus_areas#edit", as: :edit_focus_area
    patch "focus_area/:id", to: "focus_areas#update", as: :update_focus_area
    delete "focus_area/:id", to: "focus_areas#destroy", as: :destroy_focus_area
    post "focus_area/:id/reorder", to: "focus_areas#reorder", as: :reorder_focus_area
    patch "focus_area/:id/toggle", to: "focus_areas#toggle", as: :toggle_focus_area
    get "homepage/:id/edit", to: "homepages#edit", as: :edit_homepage
    get "homepage/impact_network", to: "homepage#impact_network", as: :homepage_impact_network
    post "homepage/impact_network/reorder", to: "homepage#reorder", as: :homepage_impact_network_reorder
    post "homepage/impact_network/:id/reorder", to: "homepage#reorder", as: :homepage_impact_network_reorder_item
    patch "homepage/impact_network/:id/toggle", to: "homepage#toggle", as: :homepage_impact_network_toggle
    get "homepage/hero", to: "homepage#hero", as: :homepage_hero
    patch "homepage/hero", to: "homepage#update_hero", as: :homepage_hero_update
    get "homepage/how_we_support", to: "homepage#how_we_support", as: :homepage_how_we_support
    patch "homepage/how_we_support", to: "homepage#update_how_we_support", as: :homepage_how_we_support_update
    get "homepage/who_we_are", to: "homepage#who_we_are", as: :homepage_who_we_are
    patch "homepage/who_we_are", to: "homepage#update_who_we_are", as: :homepage_who_we_are_update
    get "homepage/focus_areas", to: "homepage#focus_areas", as: :homepage_focus_areas
    get "homepage/cta", to: "homepage#cta", as: :homepage_cta
    patch "homepage/cta", to: "homepage#update_cta", as: :homepage_cta_update
    # Friendly URL for editing homepage sections
    get "homepage/sections/edit", to: "homepages#edit", as: :homepage_sections_edit
  end

  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  # Admin support ticket replies
  namespace :admin do
    resources :support_tickets do
      member do
        post :reply
      end
    end
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"
  get "about", to: "pages#about"
  get "programs", to: "pages#programs"
  get "programs/:slug", to: "pages#program_detail", as: :program_detail
  get "resources", to: "pages#resources"
  get "resources/category/:category", to: "pages#resources", as: :resources_category, constraints: { category: /blogs|knowledge-hub|opportunities|events/ }
  get "resources/:slug", to: "pages#resource_detail", as: :resource_detail
  get "startups", to: "pages#startup_directory"
  get "startups/:id/profile", to: "pages#startup_profile", as: :public_startup_profile
  get "mentors", to: "pages#mentor_directory"
  get "pricing", to: "pages#pricing"
  get "contact", to: "pages#contact"

  get "dashboard", to: redirect("/founder"), constraints: lambda { |req| req.session[:user_id].present? }
  get "profile", to: redirect("/founder/account"), constraints: lambda { |req| req.session[:user_id].present? }
  get "mentor_dashboard", to: redirect("/mentor"), constraints: lambda { |req| req.session[:user_id].present? }
  get "mentor_profile", to: redirect("/mentor/profile"), constraints: lambda { |req| req.session[:user_id].present? }
  # Use Devise pages as the canonical auth UI.
  get "login", to: redirect("/users/sign_in")
  get "signup", to: redirect("/users/sign_up")
  get "mentors_signup", to: redirect("/mentors/sign_up")

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
    post "support/tickets", to: "support_tickets#create", as: :support_tickets
    resources :support_tickets, only: [ :show ] do
      member do
        post :reply
      end
    end
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
    post "support/tickets", to: "support_tickets#create", as: :support_tickets
    resources :support_tickets, only: [ :show ] do
      member do
        post :reply
      end
    end
  end

  get "auth/google_oauth2/callback", to: "google_calendar#callback"
  get "auth/google_oauth2", as: "google_oauth2_auth", to: "google_calendar#connect"

  # Defines the root path route ("/")
  # root "posts#index"
end
