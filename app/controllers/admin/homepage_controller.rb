module Admin
  class HomepageController < RailsAdmin::MainController
    before_action :set_logos, only: %i[impact_network reorder toggle]

    def impact_network
      # @logos available for management; preview will use active logos
      @preview_logos = Logo.where(active: true).order(:display_order)
    end

    def hero
      @hero_slides = HeroSlide.where(active: true).order(:display_order)
      @preview_hero = @hero_slides
    end

    def focus_areas
      @focus_areas = FocusArea.where(active: true).order(:display_order)
    end

    def reorder
      id = params[:id]
      direction = params[:direction]
      logo = Logo.find_by(id: id)
      return redirect_to admin_homepage_impact_network_path, alert: "Logo not found" if logo.nil?

      if direction == "up"
        swap_with = Logo.where("display_order < ?", logo.display_order).order(display_order: :desc).first
      else
        swap_with = Logo.where("display_order > ?", logo.display_order).order(display_order: :asc).first
      end

      if swap_with
        logo.display_order, swap_with.display_order = swap_with.display_order, logo.display_order
        logo.save
        swap_with.save
      end

      redirect_to admin_homepage_impact_network_path, notice: "Order updated"
    end

    def toggle
      logo = Logo.find_by(id: params[:id])
      return redirect_to admin_homepage_impact_network_path, alert: "Logo not found" if logo.nil?

      logo.update(active: !logo.active)
      redirect_to admin_homepage_impact_network_path, notice: "Logo status updated"
    end

    private

    def set_logos
      @logos = Logo.order(:display_order)
    end
  end
end
