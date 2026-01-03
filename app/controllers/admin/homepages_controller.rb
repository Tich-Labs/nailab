module Admin
  # Controller: Admin::HomepagesController
  # Purpose: Central homepage sections dashboard. Renders the "Homepage — Sections"
  # editor which links to per-section editors (managed by Admin::HomepageController
  # and the resource controllers such as Admin::FocusAreasController).
  class HomepagesController < RailsAdmin::MainController
    def edit
      # id param accepted for URL compatibility (singleton homepage)
      @sections = [
        { key: "hero", title: "Hero Section", path: rails_admin.index_path(model_name: "hero_slide") },
        { key: "who_we_are", title: "Who We Are", path: "#" },
        { key: "how_we_support", title: "How Nailab Supports You", path: "#" },
        { key: "focus_areas", title: "Our Focus Areas", path: admin_homepage_focus_areas_path },
        { key: "connect_grow_impact", title: "Connect. Grow. Impact.", path: "#" },
        { key: "testimonials", title: "Testimonials", path: rails_admin.index_path(model_name: "testimonials") },
        { key: "impact_network", title: "Impact Network (Logos)", path: admin_homepage_impact_network_path },
        { key: "cta", title: "CTA Section", path: admin_homepage_cta_path }
      ]
    end
  end
end
