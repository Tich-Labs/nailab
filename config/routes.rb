Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post 'sign_in', to: 'sessions#create'
        delete 'sign_out', to: 'sessions#destroy'
        post 'sign_up', to: 'registrations#create'
      end
      resource :me, controller: 'profiles', only: [:show]
      resources :hero_slides, only: [:index]
      resources :partners, only: [:index]
      resources :testimonials, only: [:index]
      resources :programs, only: [:index, :show], param: :slug
      resources :resources, only: [:index]
      resources :startup_profiles, only: [:index]
      resources :mentor_profiles, only: [:index]
      resources :mentorship_requests, only: [:index, :create] do
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
  get 'mentors', to: 'pages#mentor_directory'
  get 'pricing', to: 'pages#pricing'
  get 'contact', to: 'pages#contact'
  get 'login', to: 'pages#login'
  get 'signup', to: 'pages#signup'

  # Defines the root path route ("/")
  # root "posts#index"
end
