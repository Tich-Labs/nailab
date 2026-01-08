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
        path: safe_path { main_app.admin_homepage_sections_edit_path },
        sections: [
          { label: "Hero Section", path: main_app.admin_homepage_hero_path, icon: "🌅" },
          { label: "Who We Are", path: main_app.admin_homepage_who_we_are_path, icon: "🤝" },
          { label: "How Nailab Supports You", path: main_app.admin_homepage_how_we_support_path, icon: "💡" },
          { label: "Our Focus Areas", path: main_app.admin_homepage_focus_areas_path, icon: "🎯" },
          { label: "Connect. Grow. Impact.", path: main_app.admin_homepage_connect_grow_impact_path, icon: "🌱" },
          { label: "Testimonials", path: main_app.admin_testimonials_path, icon: "💬" },
          { label: "Impact Network (Logos)", path: main_app.admin_homepage_impact_network_path, icon: "🏷️" },
          { label: "CTA Section", path: main_app.admin_homepage_cta_path, icon: "📣" }
        ]
      },
      {
        title: "About",
        path: safe_path { main_app.admin_about_sections_edit_path },
        sections: [
          { label: "Why Nailab Exists", path: safe_path { main_app.admin_about_section_edit_path(section: "why_nailab_exists") }, icon: "❓" },
          { label: "Our Impact", path: safe_path { main_app.admin_about_section_edit_path(section: "our_impact") }, icon: "📊" },
          { label: "Vision & Mission", path: safe_path { main_app.admin_about_section_edit_path(section: "vision_mission") }, icon: "🎯" },
          { label: "What Drives Us", path: safe_path { main_app.admin_about_section_edit_path(section: "what_drives_us") }, icon: "🔥" }
        ]
      },
      {
        title: "Pricing",
        sections: [
          { label: "Edit page", path: rails_admin.edit_path(model_name: "pricing_page", id: 1), icon: "💰" }
        ]
      },
      {
        title: "Contact Us",
        sections: [
          { label: "Edit page", path: rails_admin.edit_path(model_name: "contact_page", id: 1), icon: "📞" }
        ]
      },
      {
        title: "Programs",
        sections: [
          { label: "Edit page", path: rails_admin.edit_path(model_name: "programs_page", id: 1), icon: "📚" }
        ]
      },
      {
        title: "Resources",
        sections: [
          { label: "Blog", path: rails_admin.edit_path(model_name: "blog_page", id: 1), icon: "📝" },
          { label: "Knowledge Hub", path: rails_admin.edit_path(model_name: "knowledge_hub_page", id: 1), icon: "📚" },
          { label: "Events & Webinars", path: rails_admin.edit_path(model_name: "events_webinars_page", id: 1), icon: "🎤" },
          { label: "Opportunities", path: rails_admin.edit_path(model_name: "opportunities_page", id: 1), icon: "🎯" }
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

  # Accept a block that returns a path; if the helper or route is missing, return fallback '#'
  def safe_path
    yield
  rescue NameError, NoMethodError
    "#"
  end

  def admin_breadcrumbs
    crumbs = [ { label: "Admin", path: rails_admin.dashboard_path } ]
    crumbs << { label: action_name.titleize, path: request.path } unless action_name == "dashboard"
    crumbs
  end
end
