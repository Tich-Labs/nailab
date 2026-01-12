module Admin
  # Controller: Admin::HomepagesController
  # Purpose: Central homepage sections dashboard. Renders the "Homepage — Sections"
  # editor which links to per-section editors (managed by Admin::HomepageController
  # and the resource controllers such as Admin::FocusAreasController).
  class HomepagesController < RailsAdmin::MainController
    include AdminAuthorization
    def edit
      # id param accepted for URL compatibility (singleton homepage)
      @sections = [
        { key: "hero", title: "Hero Section", path: admin_homepage_hero_path },
        { key: "who_we_are", title: "Who We Are", path: admin_homepage_who_we_are_path },
        { key: "how_we_support", title: "How Nailab Supports You", path: admin_homepage_how_we_support_path },
        { key: "focus_areas", title: "Our Focus Areas", path: admin_homepage_focus_areas_path },
        { key: "connect_grow_impact", title: "Connect. Grow. Impact.", path: admin_homepage_connect_grow_impact_path },
        { key: "testimonials", title: "Testimonials", path: rails_admin.index_path(model_name: "testimonial") },
        { key: "impact_network", title: "Impact Network (Logos)", path: admin_homepage_impact_network_path },
        { key: "cta", title: "CTA Section", path: admin_homepage_cta_path }
      ]
    end
  end
end
