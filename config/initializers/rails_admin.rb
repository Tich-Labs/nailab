MARKETING_CONTENT_MENU = {
  'Home • Hero slides' => '/admin/hero_slide',
  'Home • Structured content' => '/admin/static_page?f[slug_eq]=home',
  'About page' => '/admin/static_page?f[slug_eq]=about',
  'Programs' => '/admin/program',
  'Resources' => '/admin/resource',
  'Startup directory' => '/admin/startup_profile',
  'Pricing page' => '/admin/static_page?f[slug_eq]=pricing',
  'Contact page' => '/admin/static_page?f[slug_eq]=contact',
  'Partners' => '/admin/partner',
  'Testimonials' => '/admin/testimonial',
  'Focus areas' => '/admin/focus_area'
}.freeze

RailsAdmin.config do |config|
  config.asset_source = :sprockets
  config.navigation_static_label = 'Pages & Marketing Content'
  config.navigation_static_links = MARKETING_CONTENT_MENU

  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end

  HIDDEN_MARKETING_MODELS = %w[StaticPage HeroSlide FocusArea Testimonial Partner Program Resource StartupProfile]
  HIDDEN_MARKETING_MODELS.each do |model_name|
    config.model model_name do
      visible false
    end
  end

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

  config.model 'StaticPage' do
    navigation_label 'Marketing'
    label_plural 'Landing + page content'
    weight 0

    list do
      sort_by :updated_at
      field :title
      field :slug
      field :updated_at
    end

    edit do
      field :title do
        help 'Page title shown in the header and the browser tab.'
      end
      field :slug do
        help 'System slug for routing (home/about/pricing/contact). Locked for reserved pages.'
        read_only do
          bindings[:object].persisted? && StaticPage::RESERVED_SLUGS.include?(bindings[:object].slug_was)
        end
      end
      field :content do
        help 'Main content for the public page. Accepts HTML/markdown.'
      end
      field :structured_content do
        help 'Advanced structured blocks used on the home page; edit with care.'
      end
    end
  end

  config.model 'HeroSlide' do
    navigation_label 'Marketing'
    weight 1

    list do
      sort_by :display_order
      field :title
      field :active
      field :display_order
      field :updated_at
    end

    edit do
      field :title
      field :subtitle
      field :cta_text do
        help 'Primary CTA text shown on the slide.'
      end
      field :cta_link do
        help 'Primary CTA URL; make sure it begins with https://.'
      end
      field :image_url do
        help 'URL of the hero image. Upload to your CDN and paste the public link.'
      end
      field :display_order
      field :active
    end
  end

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

  # == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true
end

RailsAdmin::Config::Actions::ShowInApp.class_eval do
  register_instance_option :link_url do
    target = bindings[:object].try(:rails_admin_preview_path)
    target || bindings[:view].main_app.root_path
  end

  register_instance_option :controller do
    proc do
      target = @object.try(:rails_admin_preview_path) || controller.main_app.root_path
      redirect_to target
    end
  end
end
