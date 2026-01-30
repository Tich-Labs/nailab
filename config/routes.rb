Rails.application.routes.draw do
  # Local-only email inbox for ActionMailer (Devise confirmations, resets, etc.)
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # (Removed legacy admin/pricing_page/sections routes — pricing editor consolidated)
  namespace :admin do
    resources :about_sections
    resources :resources, param: :id do
      member do
        get :preview
      end
    end
  end
  get "partner_onboarding", to: "partner_onboarding#show", as: :partner_onboarding
  put "partner_onboarding", to: "partner_onboarding#update"
  get "founder_onboarding", to: "founder_onboarding#show", as: :founder_onboarding
  put "founder_onboarding", to: "founder_onboarding#update"
  patch "founder_onboarding/save_and_exit", to: "founder_onboarding#save_and_exit", as: :founder_onboarding_save_and_exit
  get "mentor_onboarding", to: "mentor_onboarding#show", as: :mentor_onboarding
  put "mentor_onboarding", to: "mentor_onboarding#update"
  patch "mentor_onboarding/save_and_exit", to: "mentor_onboarding#save_and_exit", as: :mentor_onboarding_save_and_exit
  get "mentor_onboarding/completed", to: "mentor_onboarding#completed", as: :mentor_onboarding_completed
  get "founder_onboarding/completed", to: "founder_onboarding#completed", as: :founder_onboarding_completed
  get "partner_onboarding/completed", to: "partner_onboarding#completed", as: :partner_onboarding_completed

  # Development/test helper: confirm email in-browser by token for testing flows.
  if Rails.env.development? || Rails.env.test?
    get "dev/confirm_email/:token", to: "dev_confirmations#confirm", as: :dev_confirm_email
  end
  missing_font = lambda do |_env|
    [ 204, { "Content-Type" => "font/woff2", "Cache-Control" => "public, max-age=86400" }, [] ]
  end
  missing_favicon = lambda do |_env|
    [ 204, { "Content-Type" => "image/x-icon", "Cache-Control" => "public, max-age=86400" }, [] ]
  end

  get "/favicon.ico", to: missing_favicon
  get "/assets/fonts/gotham/*font", to: missing_font

  devise_for :users, controllers: {
    registrations: "registrations",
    omniauth_callbacks: "users/omniauth_callbacks",
    passwords: "passwords",
    confirmations: "confirmations",
    sessions: "users/sessions"
  }
  devise_scope :user do
    get "mentors/sign_up", to: "registrations#new", as: :new_mentor_registration, defaults: { role: "mentor" }
    post "mentors", to: "registrations#create", as: :mentor_registration, defaults: { role: "mentor" }
    get "founders/sign_up", to: "registrations#new", as: :new_founder_registration, defaults: { role: "founder" }
    post "founders", to: "registrations#create", as: :founder_registration, defaults: { role: "founder" }
    get "registrations/pending", to: "registrations#pending", as: :registrations_pending
    post "sign_in", to: "sessions#create"
    delete "sign_out", to: "sessions#destroy"
  end

  # Founder onboarding routes
  get "/founder_onboarding", to: "founder_onboarding#show"
  patch "/founder_onboarding", to: "founder_onboarding#update"

  resources :notifications, only: [ :index ] do
    post :mark_all_read, on: :collection
     post :mark_read, on: :member
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

  # Custom admin homepage editors and logo management — define before mounting RailsAdmin
  namespace :admin do
    # Friendly slug routes for pricing editor (allows /admin/pricing/pricing/edit)
    # Simple routes for pricing editor (no redundant slug)
    get "pricing/edit", to: "pricing_page#edit", as: :edit_admin_pricing_page_simple
    patch "pricing", to: "pricing_page#update", as: :admin_pricing_page_simple

    # Friendly slug routes for pricing editor (allows /admin/pricing/pricing/edit)
    get "pricing/:slug/edit", to: "pricing_page#edit", as: :edit_admin_pricing_page_slug
    patch "pricing/:slug", to: "pricing_page#update", as: :admin_pricing_page_slug

    # Friendly slug routes for contact editor (allows /admin/contact_page/contact/edit)
    get "contact_page/:slug/edit", to: "contact_page#edit", as: :edit_admin_contact_page_slug
    patch "contact_page/:slug", to: "contact_page#update", as: :admin_contact_page_slug
    # Simple routes for contact editor (no id)
    get "contact_page/edit", to: "contact_page#edit", as: :edit_admin_contact_page
    patch "contact_page", to: "contact_page#update", as: :admin_contact_page

    resources :logos, only: %i[index new create update destroy]
    resources :testimonials, only: %i[index new create edit update destroy]
    resources :pricing_page, only: %i[edit update]
    resources :programs_page, only: %i[edit update]
    resources :programs, only: %i[create]
    resources :contact_page, only: %i[edit update]
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
    get "homepage/connect_grow_impact", to: "homepage#connect_grow_impact", as: :homepage_connect_grow_impact
    patch "homepage/connect_grow_impact", to: "homepage#update_connect_grow_impact", as: :homepage_connect_grow_impact_update
    get "homepage/who_we_are", to: "homepage#who_we_are", as: :homepage_who_we_are
    patch "homepage/who_we_are", to: "homepage#update_who_we_are", as: :homepage_who_we_are_update
    get "homepage/focus_areas", to: "homepage#focus_areas", as: :homepage_focus_areas
    get "homepage/cta", to: "homepage#cta", as: :homepage_cta
    patch "homepage/cta", to: "homepage#update_cta", as: :homepage_cta_update
    # Friendly URL for editing homepage sections
    get "homepage/sections/edit", to: "homepages#edit", as: :homepage_sections_edit
    get "about/sections/edit", to: "abouts#edit", as: :about_sections_edit
    get "about/sections/:section/edit", to: "abouts#edit_section", as: :about_section_edit
    patch "about/sections/:section", to: "abouts#update_section", as: :about_section_update
    post "about/sections/:section", to: "abouts#update_section"
    get "admin/homepage/our_impact", to: "admin/homepage#our_impact"
    patch "admin/homepage/our_impact", to: "admin/homepage#update_our_impact"
  end

  namespace :admin do
    resources :user_profiles, only: %i[index show] do
      member do
        post :approve
        post :reject
      end
    end
  end

  namespace :admin do
    resources :mentorship_requests, only: %i[index]
    resources :support_tickets, only: %i[index] do
      member do
        post :reply
      end
    end
  end

  # Redirect the plural admin path to RailsAdmin's singular model path
  get "/admin/startup_profiles", to: redirect("/admin/startup_profile")

  # Backwards-compatible redirect: singular support_ticket -> support_tickets
  get "/admin/support_ticket", to: redirect("/admin/support_tickets")

  # Backwards-compatible redirect: singular mentorship_request -> mentorship_requests
  get "/admin/mentorship_request", to: redirect("/admin/mentorship_requests")

  # Serve a custom admin grid for StartupProfile at the RailsAdmin model path
  # This route must come before mounting the RailsAdmin engine so it takes precedence.
  get "/admin/startup_profile", to: "admin/startup_profiles#index"
  post "/admin/startup_profile/:id/approve", to: "admin/startup_profiles#approve", as: :approve_admin_startup_profile
  post "/admin/startup_profile/:id/reject", to: "admin/startup_profiles#reject", as: :reject_admin_startup_profile
  post "/admin/startup_profile/:id/archive", to: "admin/startup_profiles#archive", as: :archive_admin_startup_profile
  get "/admin/startup_profile/:id", to: "admin/startup_profiles#show", as: :admin_startup_profile_show
  patch "/admin/startup_profile/:id", to: "admin/startup_profiles#update", as: :admin_startup_profile_update

  mount RailsAdmin::Engine => "/admin", as: "rails_admin"


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
  post "contact", to: "pages#create_contact_message"
  get "terms", to: "pages#terms"
  get "privacy", to: "pages#privacy"

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
  resource :profile, only: [ :show ]

    resource(:startup_profile, only: %i[show edit update])
    resource(:progress, only: %i[show])
    resources(:milestones)
    resources(:monthly_metrics, only: %i[new create edit update index])

    # Startup Updates feature
    resources :startup_updates, only: [ :index, :new, :create ]

    # Allow founders to add additional startups after onboarding
    resources :startups, only: %i[new create]

    resources :startup_invites, only: [ :new, :create ]

    get "mentorship", to: "mentorship#index"
    resources(:mentors, only: %i[index show])
    resources(:mentorship_requests, only: %i[index show new create edit update destroy])
    resources(:sessions, only: %i[index show new create])

    resources(:conversations, path: "messages", only: %i[index show]) do
      resources(:messages, only: %i[create])
      member do
        post :create_message
      end
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
    post "community/cleanup_empty_profiles", to: "community#cleanup_empty_profiles", as: :cleanup_empty_startup_profiles
    resources(:connections, only: %i[create])
    resources(:peer_messages, only: %i[index create])

    resource(:account, controller: "account", only: %i[show edit update destroy])
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

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  # Public invite acceptance
  get "invites/accept", to: "invites#accept", as: :accept_invites

  get "auth/google_oauth2/callback", to: "google_calendar#callback"
  get "auth/google_oauth2", as: "google_oauth2_auth", to: "google_calendar#connect"

  # Defines the root path route ("/")
  # root "posts#index"
end
