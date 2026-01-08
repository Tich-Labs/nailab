RailsAdmin.config do |config|
    config.model "Mentor" do
      navigation_label "Mentorship"
      weight 15
    end
  config.asset_source = :sprockets

  # Register content management page models for admin editing

  config.navigation_static_links = {
    "Resources" => "/admin/resources",
    "Blog" => "/admin/resources?resource_type=blog",
    "Knowledge Hub" => "/admin/resources?resource_type=template",
    "Events & Webinars" => "/admin/resources?resource_type=event",
    "Opportunities" => "/admin/resources?resource_type=opportunity"
  }

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

  # Remove redundant/internal models from RailsAdmin entirely (no nav + no direct /admin/<model> access).
  config.excluded_models ||= []
  config.excluded_models += %w[
    User
    UserProfile
    Identity
    Notification
    JwtDenylist
    Conversation
    Message
    PeerMessage
    Opportunity
    Milestone
    OpportunitySubmission
    HeroSlide
  ]

  # Hide individual models since we have organized access via static links
  HIDDEN_MODELS = %w[FocusArea Testimonial Partner Program Resource StartupProfile]
  HIDDEN_MODELS.each do |model_name|
    config.model model_name do
      visible false
    end
  end

  # Configure SupportTicket for conversation-style management
  config.model "SupportTicket" do
    navigation_label "Support"
    weight 50

    # Disable edit action since replies are handled through show page
    config.actions do
      dashboard
      index
      new
      export
      bulk_delete
      show
      delete
    end

    list do
      field :id
      field :subject
      field :user do
        pretty_value do
          value&.full_name || value&.email
        end
      end
      field :portal
      field :category
      field :status, :enum do
        enum do
          { "open" => "open", "in_progress" => "in_progress", "resolved" => "resolved", "closed" => "closed" }
        end
        pretty_value do
          status_colors = {
            "open" => "badge badge-warning",
            "in_progress" => "badge badge-info",
            "resolved" => "badge badge-success",
            "closed" => "badge badge-secondary"
          }
          css_class = status_colors[value] || "badge badge-default"
          "<span class='#{css_class}'>#{value.humanize}</span>".html_safe
        end
      end
      field :created_at
      field :updated_at
    end

    show do
      field :id
      field :subject
      field :user do
        pretty_value do
          value&.full_name || value&.email
        end
      end
      field :portal
      field :category
      field :status, :enum do
        enum do
          { "open" => "open", "in_progress" => "in_progress", "resolved" => "resolved", "closed" => "closed" }
        end
        pretty_value do
          status_colors = {
            "open" => "badge badge-warning",
            "in_progress" => "badge badge-info",
            "resolved" => "badge badge-success",
            "closed" => "badge badge-secondary"
          }
          css_class = status_colors[value] || "badge badge-default"
          "<span class='#{css_class}'>#{value.humanize}</span>".html_safe
        end
      end
      field :created_at
      field :updated_at

      # Show conversation thread
      field :replies do
        label "Conversation"
        pretty_value do
          replies = value.order(:created_at)
          html = "<div class='conversation-thread' style='margin-top: 20px;'>"
          replies.each do |reply|
            sender = reply.admin_reply? ? "Admin" : (reply.user&.full_name || reply.user&.email || "User")
            is_admin = reply.admin_reply?
            alert_class = is_admin ? "alert-info" : "alert-success"
            align_class = is_admin ? "text-right" : "text-left"

            html += "<div class='message-container #{align_class}' style='margin-bottom: 15px;'>"
            html += "<div class='alert #{alert_class}' style='display: inline-block; max-width: 80%; border-radius: 10px; padding: 12px 15px;'>"
            html += "<div style='font-size: 12px; color: #666; margin-bottom: 5px;'>"
            html += "<strong>#{sender}</strong> - #{reply.created_at.strftime('%b %d, %Y at %I:%M %p')}"
            html += "</div>"
            html += "<div style='white-space: pre-wrap; word-wrap: break-word;'>#{reply.body}</div>"
            html += "</div>"
            html += "</div>"
          end
          html += "</div>"
          html += "<div style='margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd;'>"
          html += "<h4 style='margin-bottom: 20px; color: #333;'>Send Reply</h4>"
          html += "<form action='/admin/support_tickets/#{bindings[:object].id}/reply' method='post'>"
          html += "<div class='form-group' style='margin-bottom: 15px;'>"
          html += "<label for='message' style='display: block; margin-bottom: 5px; font-weight: bold;'>Your Reply</label>"
          html += "<textarea name='message' id='message' class='form-control' rows='6' required style='width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;'></textarea>"
          html += "</div>"
          html += "<div class='form-group' style='margin-bottom: 15px;'>"
          html += "<label for='status' style='display: block; margin-bottom: 5px; font-weight: bold;'>Update Status (optional)</label>"
          html += "<select name='status' id='status' class='form-control' style='width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;'>"
          html += "<option value=''>Keep current status</option>"
          html += "<option value='open'>Open</option>"
          html += "<option value='in_progress'>In Progress</option>"
          html += "<option value='resolved'>Resolved</option>"
          html += "<option value='closed'>Closed</option>"
          html += "</select>"
          html += "</div>"
          html += "<div class='form-group'>"
          html += "<button type='submit' class='btn btn-primary' style='padding: 10px 20px; margin-right: 10px;'>"
          html += "<i class='fa fa-send'></i> Send Reply"
          html += "</button>"
          html += "</div>"
          html += "</form>"
          html += "</div>"
          html.html_safe
        end
      end
    end
  end

  # Structure admin navigation - models appear below the static links
  config.model "Program" do
    navigation_label "Marketing"
    weight 10
  end

  # Expose HeroSlide in Content Management
  begin
    config.model "HeroSlide" do
      navigation_label "Content Management"
      weight 2
      list do
        fields(*HeroSlide.attribute_names.map(&:to_sym))
      end
      edit do
        fields(*HeroSlide.attribute_names.map(&:to_sym))
      end
    end
  rescue NameError
    # model not present in this environment
  end

  # Expose Testimonial in Content Management
  begin
    config.model "Testimonial" do
      navigation_label "Content Management"
      weight 3
      list do
        fields(*Testimonial.attribute_names.map(&:to_sym))
      end
      edit do
        fields(*Testimonial.attribute_names.map(&:to_sym))
      end
    end
  rescue NameError
  end

  # Expose FocusArea in Content Management
  begin
    config.model "FocusArea" do
      navigation_label "Content Management"
      weight 4
      list do
        fields(*FocusArea.attribute_names.map(&:to_sym))
      end
      edit do
        fields(*FocusArea.attribute_names.map(&:to_sym))
      end
    end
  rescue NameError
  end

  # Expose Logo in Content Management (ActiveStorage)
  begin
    config.model "Logo" do
      navigation_label "Content Management"
      weight 5
      list do
        field :id
        field :name
        field :display_order
        field :active
        field :image do
          pretty_value do
            if bindings[:object].respond_to?(:image) && bindings[:object].image.attached?
              bindings[:view].image_tag(bindings[:object].image.variant(resize_to_limit: [ 200, 80 ]))
            else
              "No image"
            end
          end
        end
      end

      edit do
        field :name
        field :image, :active_storage
        field :display_order
        field :active
      end
    end
  rescue NameError
  end

  config.model "Resource" do
    navigation_label "Marketing"
    weight 11
  end

  config.model "StartupProfile" do
    navigation_label "Marketing"
    weight 12
  end

  config.model "MentorshipRequest" do
    navigation_label "Mentorship"
    weight 30
  end
  config.model "MentorshipConnection" do
    navigation_label "Mentorship"
    weight 31
  end

  config.model "Startup" do
    navigation_label "System"
    weight 41
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
