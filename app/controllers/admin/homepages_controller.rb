module Admin
  class HomepagesController < RailsAdmin::MainController
    def edit
      # id param accepted for URL compatibility (singleton homepage)
      @sections = [
        { key: "hero", title: "Hero Section", path: rails_admin.index_path(model_name: "hero_slide") },
        { key: "who_we_are", title: "Who We Are", path: "#" },
        { key: "how_we_support", title: "How Nailab Supports You", path: "#" },
        { key: "focus_areas", title: "Our Focus Areas", path: admin_focus_areas_path },
        { key: "connect_grow_impact", title: "Connect. Grow. Impact.", path: "#" },
        { key: "testimonials", title: "Testimonials", path: rails_admin.index_path(model_name: "testimonial") },
        { key: "impact_network", title: "Impact Network (Logos)", path: admin_homepage_impact_network_path }
      ]
    end
  end
end
