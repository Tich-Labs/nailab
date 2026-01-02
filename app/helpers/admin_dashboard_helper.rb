module AdminDashboardHelper
  def admin_sidebar_groups
    [
      {
        title: "� DASHBOARD",
        sections: [
          { label: "Dashboard Overview", path: "/admin", icon: "📊" }
        ]
      },
      {
        title: "�📄 CONTENT MANAGEMENT",
        sections: [
          { label: "Homepage", path: admin_homepage_sections_edit_path, icon: "🏠" },
          { label: "About", path: rails_admin.edit_path(model_name: "about_page", id: 1), icon: "📖" },
          { label: "Pricing", path: rails_admin.edit_path(model_name: "pricing_page", id: 1), icon: "💰" },
          { label: "Contact Us", path: rails_admin.edit_path(model_name: "contact_page", id: 1), icon: "📞" },
          { label: "Programs", path: rails_admin.edit_path(model_name: "programs_page", id: 1), icon: "📚" },
          { label: "Resources: Blog", path: rails_admin.edit_path(model_name: "blog_page", id: 1), icon: "📝" },
          { label: "Resources: Knowledge Hub", path: rails_admin.edit_path(model_name: "knowledge_hub_page", id: 1), icon: "🧠" },
          { label: "Resources: Events & Webinars", path: rails_admin.edit_path(model_name: "events_webinars_page", id: 1), icon: "🎤" },
          { label: "Resources: Opportunities", path: rails_admin.edit_path(model_name: "opportunities_page", id: 1), icon: "🎯" }
        ]
      },
      {
        title: "👥 Mentorship",
        sections: [
            { label: "Mentors", path: rails_admin.index_path(model_name: "mentor"), icon: "🧑‍🏫" },
            { label: "Requests", path: rails_admin.index_path(model_name: "mentorship_request"), icon: "🧾", badge: @admin_pending_requests, description: "View mentorship requests with mentor, mentee, and details" }
        ]
      },
      {
        title: "💼 Startups",
        sections: [
          { label: "Startups", path: rails_admin.index_path(model_name: "startup_profile"), icon: "🚀" }
        ]
      },
      {
        title: "💬 Messaging & Comms",
        sections: [
          { label: "Support Tickets", path: rails_admin.index_path(model_name: "support_ticket"), icon: "🎫" }
        ]
      }
    ]
  end

  def admin_status_tag(status)
    color = case status.to_s
    when /pending/ then "bg-amber-100 text-amber-700"
    when /accepted|approved/ then "bg-emerald-100 text-emerald-700"
    when /declined/ then "bg-rose-100 text-rose-700"
    else "bg-slate-100 text-slate-700"
    end
    content_tag(:span, status.to_s.humanize, class: "rounded-full px-2 py-0.5 text-xs font-semibold #{color}")
  end

  def admin_breadcrumbs
    crumbs = [ { label: "Admin", path: rails_admin.dashboard_path } ]
    if params[:controller]&.start_with?("rails_admin/")
      # Add model name if present
      if params[:model_name].present?
        model_label = params[:model_name].to_s.titleize
        model_path = rails_admin.index_path(model_name: params[:model_name])
        crumbs << { label: model_label, path: model_path }
      end
      # Add object label if editing/showing a record
      if params[:action].in?([ "show", "edit" ]) && defined?(@object)
        # Try to use a user-friendly label for the object
        object_label = if @object.respond_to?(:full_name) && @object.full_name.present?
          @object.full_name
        elsif @object.respond_to?(:name) && @object.name.present?
          @object.name
        elsif @object.respond_to?(:email) && @object.email.present?
          @object.email
        elsif @object.respond_to?(:title) && @object.title.present?
          @object.title
        elsif @object.respond_to?(:id)
          "##{@object.class.name} #{@object.id}"
        else
          @object.to_s
        end
        crumbs << { label: object_label, path: request.path }
      elsif params[:action] && !%w[index dashboard].include?(params[:action])
        crumbs << { label: params[:action].titleize, path: request.path }
      end
    else
      # Special-case: Admin homepage sections edit should read: Admin > SECTIONS > Edit
      if params[:controller] == "admin/homepages" && params[:action] == "edit"
        # named route: admin_homepage_sections_edit_path -> helper generated as admin_homepage_sections_edit_path
        begin
          crumbs << { label: "Sections", path: admin_homepage_sections_edit_path }
        rescue StandardError
          crumbs << { label: "Sections", path: request.path }
        end
        crumbs << { label: action_name.titleize, path: request.path }
      else
        crumbs << { label: action_name.titleize, path: request.path } unless action_name == "dashboard"
      end
    end
    crumbs
  end
end
