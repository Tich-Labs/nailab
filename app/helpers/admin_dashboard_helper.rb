module AdminDashboardHelper
  HOMEPAGE_SECTION_LABELS = {
    "hero" => "Hero Section",
    "focus_areas" => "Our Focus Areas",
    "impact_network" => "Impact Network (Logos)",
    "cta" => "CTA Section",
    "sections" => "Sections"
  }.freeze

  def admin_sidebar_groups
    [
      {
        title: "🏠 Homepage",
        path: safe_path { "/admin/homepage/sections/edit" },
        sections: [
          { label: "Hero Section", path: "/admin/homepage/hero", icon: "🌅" },
          { label: "Who We Are", path: "/admin/homepage/who_we_are", icon: "🤝" },
          { label: "How Nailab Supports You", path: "/admin/homepage/how_we_support", icon: "💡" },
          { label: "Our Focus Areas", path: "/admin/homepage/focus_areas", icon: "🎯" },
          { label: "Connect. Grow. Impact.", path: "/admin/homepage/connect_grow_impact", icon: "🌱" },
          { label: "Testimonials", path: "/admin/testimonials", icon: "💬" },
          { label: "Impact Network (Logos)", path: "/admin/homepage/impact_network", icon: "🏷️" },
          { label: "CTA Section", path: "/admin/homepage/cta", icon: "📣" }
        ]
      },
      {
        title: "About",
        path: safe_path { "/admin/about/sections/edit" },
        sections: [
          { label: "Why Nailab Exists", path: "/admin/about/sections/why_nailab_exists/edit", icon: "❓" },
          { label: "Our Impact", path: "/admin/about/sections/our_impact/edit", icon: "📊" },
          { label: "Vision & Mission", path: "/admin/about/sections/vision_mission/edit", icon: "🎯" },
          { label: "What Drives Us", path: "/admin/about/sections/what_drives_us/edit", icon: "🔥" }
        ]
      },
      {
        title: "Pricing",
        path: safe_path { "/admin/pricing/edit" },
        sections: [
          { label: "Edit page", path: "/admin/pricing/edit", icon: "💰" }
        ]
      },
      {
        title: "Contact Us",
        path: safe_path { "/admin/contact_page/edit" },
        sections: [
          { label: "Edit page", path: "/admin/contact_page/edit", icon: "📞" }
        ]
      },
      {
        title: "Programs (Coming soon)",
        path: safe_path { "#" },
        sections: [
          { label: "Coming soon", path: "#" }
        ]
      },
      {
        title: "Resources (Coming soon)",
        path: safe_path { "#" },
        sections: [
          { label: "Coming soon", path: "#" }
        ]
      },
      {
        title: "👥 Mentorship",
        path: safe_path { "/admin/mentor" },
        sections: [
          { label: "Mentors", path: "/admin/mentor" },
          { label: "Requests", path: "/admin/mentorship_request", badge: @admin_pending_requests }
        ]
      },
      {
        title: "💼 Startups",
        path: safe_path { "/admin/startup_profile" },
        sections: [
          { label: "Startups", path: "/admin/startup_profile", badge: @admin_pending_startup_approvals }
        ]
      },
      {
        title: "💬 Messaging & Comms",
        path: safe_path { "/admin/support_ticket" },
        sections: [
          { label: "Support Tickets", path: "/admin/support_ticket" }
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

  def safe_path(&block)
    if block.respond_to?(:call)
      yield block
    else
      "#"
    end
  rescue NameError, NoMethodError
    "#"
  end

  def admin_breadcrumbs
    crumbs = [ { label: "Admin", path: rails_admin.dashboard_path } ]
    if params[:controller]&.start_with?("rails_admin/")
      if params[:model_name].present?
        model_label = if @object.respond_to?(:full_name) && @object.full_name.present?
          @object.full_name
        elsif @object.respond_to?(:name) && @object.name.present?
          @object.email
        elsif @object.respond_to?(:id)
          "##{@object.class.name} #{@object.id}"
        else
          @object.to_s
        end

        begin
          admin_obj_path = if defined?(rails_admin) && params[:model_name].present? && @object.respond_to?(:id)
            rails_admin.show_path(model_name: params[:model_name], id: @object.id)
          else
            request.path
          end
        rescue StandardError
          admin_obj_path = request.path
        end

        crumbs << { label: model_label, path: admin_obj_path }
      end
    elsif params[:controller] == "admin/homepage"
      crumbs << { label: "Homepage", path: admin_homepage_sections_edit_path }
      section_label = HOMEPAGE_SECTION_LABELS[params[:action]] || action_name.titleize
      crumbs << { label: section_label, path: request.path }
    elsif params[:controller] == "admin/homepages" && params[:action] == "edit"
      begin
        crumbs << { label: "Sections", path: admin_homepage_sections_edit_path }
      rescue StandardError
        crumbs << { label: "Sections", path: request.path }
      end
      crumbs << { label: action_name.titleize, path: request.path }
    else
      crumbs << { label: action_name.titleize, path: request.path } unless action_name == "dashboard"
    end
    crumbs
  end
end
