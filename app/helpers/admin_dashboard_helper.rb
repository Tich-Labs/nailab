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
        title: "Content Management",
        sections: [
          { label: "Homepage Sections", path: main_app.admin_homepage_sections_edit_path },
          { label: "About Sections", path: main_app.admin_about_sections_edit_path },
          { label: "Pricing Page", path: main_app.admin_pricing_page_sections_edit_path },
          { label: "Contact Page", path: main_app.admin_contact_us_sections_edit_path }
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
    crumbs = [{ label: "Admin", path: rails_admin.dashboard_path }]
    crumbs << { label: action_name.titleize, path: request.path } unless action_name == "dashboard"
    crumbs
  end
end
