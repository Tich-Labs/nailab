RailsAdmin.config do |config|
  # ...existing config...

  config.model "StaticPage" do
    navigation_label "MARKETING PAGES"
    label_plural "Landing + page content"
    weight 0

    list do
      sort_by :updated_at
      field :title
      field :slug
      field :updated_at
    end

    edit do
      field :title do
        help "Page title shown in the header and the browser tab."
      end
      field :slug do
        help "System slug for routing (home/about/pricing/contact). Locked for reserved pages."
        read_only do
          bindings[:object].persisted? && StaticPage::RESERVED_SLUGS.include?(bindings[:object].slug_was)
        end
      end
      field :content do
        help "Main content for the public page. Accepts HTML/markdown."
        read_only do
          bindings[:object].slug == "contact"
        end
        visible do
          true
        end
        pretty_value do
          if bindings[:object].slug == "contact"
            "Contact Nailab using the form below. Edit this content in the admin to update contact details."
          else
            value
          end
        end
      end

      group :contact_info do
        label "Contact Information"
        active do
          bindings[:object].slug == "contact"
        end
        field :contact_intro do
          label "Contact Intro Text"
          help "Intro text shown at the top of the Contact Us page."
          visible true
        end
        field :contact_email do
          label "Contact Email"
          visible true
        end
        field :contact_phone do
          label "Contact Phone"
          visible true
        end
        field :contact_address do
          label "Contact Address"
          visible true
        end
      end

      group :faq_info do
        label "Frequently Asked Questions"
        active do
          bindings[:object].slug == "contact"
        end
        (1..8).each do |i|
          field "faq_q"+i.to_s do
            label "FAQ \\##{i} Question"
            help "Leave blank to hide."
            visible true
          end
          field "faq_a"+i.to_s, :text do
            label "FAQ \\##{i} Answer"
            help "Use Enter/Return for new lines. Line breaks will appear on the site. Leave blank to hide."
            visible true
          end
        end
      end

      # Hide raw structured_content for contact page
      field :structured_content do
        help "Advanced structured blocks used on the home page; edit with care."
        visible do
          bindings[:object].slug != "contact"
        end
      end
    end
  end
  # ...rest of config...
end
MARKETING_CONTENT_MENU = {
  "Homepage" => "/admin/static_page?f[slug_eq]=home",
  "About" => "/admin/static_page?f[slug_eq]=about",
  "Pricing" => "/admin/static_page?f[slug_eq]=pricing",
  "Contact Us" => "/admin/static_page?f[slug_eq]=contact",
  "Programs" => "/admin/program",
  "Resources: Blog" => "/admin/resource?category=blog",
  "Resources: Knowledge Hub" => "/admin/resource?category=knowledge_hub",
  "Resources: Events & Webinars" => "/admin/resource?category=events_webinars",
  "Resources: Opportunities" => "/admin/resource?category=opportunities"
}.freeze

RailsAdmin.config do |config|
  config.asset_source = :sprockets
  config.navigation_static_label = "MARKETING PAGES"
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

  HIDDEN_MARKETING_MODELS = %w[StaticPage FocusArea Testimonial Partner Program Resource StartupProfile]
  HIDDEN_MARKETING_MODELS.each do |model_name|
    config.model model_name do
      visible false
    end
  end

  # Structure admin navigation
  # Navigation labels and weights are set above for all MARKETING PAGES models


  # Removed HeroSlide admin config

  config.model "Program" do
    navigation_label "Marketing"
    weight 5
  end

  config.model "Resource" do
    navigation_label "Marketing"
    weight 6
  end

  config.model "StartupProfile" do
    navigation_label "Marketing"
    weight 7
  end
  config.model "User" do
    navigation_label "Users & Auth"
  end
  config.model "UserProfile" do
    navigation_label "Users & Auth"
  end
  config.model "MentorshipRequest" do
    navigation_label "Users & Auth"
  end
  config.model "MentorshipConnection" do
    navigation_label "Users & Auth"
  end

  config.model "Notification" do
    navigation_label "System"
  end
  config.model "Startup" do
    navigation_label "System"
  end
  config.model "JwtDenylist" do
    navigation_label "System"
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
