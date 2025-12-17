MARKETING_CONTENT_MENU = {
  'Home • hero slides' => '/admin/hero_slide',
  'Home • structured content' => '/admin/static_page?f[slug_eq]=home',
  'Focus areas & support' => '/admin/focus_area',
  'Testimonials' => '/admin/testimonial',
  'Partners' => '/admin/partner',
  'Programs' => '/admin/program',
  'Resources' => '/admin/resource',
  'Startup directory' => '/admin/startup_profile',
  'About Nailab page' => '/admin/static_page?f[slug_eq]=about',
  'Pricing page' => '/admin/static_page?f[slug_eq]=pricing',
  'Contact page' => '/admin/static_page?f[slug_eq]=contact'
}.freeze

RailsAdmin.config do |config|
  config.asset_source = :sprockets
  config.navigation_static_label = 'Marketing layout'
  config.navigation_static_links = MARKETING_CONTENT_MENU

  # Structure admin navigation
  config.model 'Program' do
    navigation_label 'Marketing'
    weight 5
  end
  config.model 'Resource' do
    navigation_label 'Marketing'
    weight 6
  end
  config.model 'StartupProfile' do
    navigation_label 'Marketing'
    weight 7
  end
  config.model 'Testimonial' do
    navigation_label 'Marketing'
    weight 3
  end
  config.model 'Partner' do
    navigation_label 'Marketing'
    weight 4
  end
  config.model 'FocusArea' do
    navigation_label 'Marketing'
    weight 2
  end
  config.model 'HeroSlide' do
    navigation_label 'Marketing'
    weight 1
  end
  config.model 'StaticPage' do
    navigation_label 'Marketing'
    label_plural 'Landing + page content'
    weight 0
  end

  config.model 'User' do
    navigation_label 'Users & Auth'
  end
  config.model 'UserProfile' do
    navigation_label 'Users & Auth'
  end
  config.model 'MentorshipRequest' do
    navigation_label 'Users & Auth'
  end
  config.model 'MentorshipConnection' do
    navigation_label 'Users & Auth'
  end

  config.model 'Notification' do
    navigation_label 'System'
  end
  config.model 'Startup' do
    navigation_label 'System'
  end
  config.model 'JwtDenylist' do
    navigation_label 'System'
  end

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
