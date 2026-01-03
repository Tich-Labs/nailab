require "ostruct"

module Admin
  # Controller: Admin::HomepageController
  # Purpose: Per-homepage section editors (hero, impact_network, focus_areas).
  # Renders the per-section admin pages located in `app/views/admin/homepage/`.
  # Use `Admin::HomepagesController` for the central homepage sections dashboard.
  class HomepageController < RailsAdmin::MainController
    include AdminLayoutData
      before_action :set_logos, only: %i[impact_network reorder toggle]
      before_action :prepare_home_content, only: %i[hero update_hero cta update_cta]
      HERO_DEFAULT = {
        title: "Grow your startup with people who’ve done it before.",
        subtitle: "Book weekly 1-on-1 mentorship sessions with seasoned business leaders and build your startup alongside a supportive community of founders actively building high-growth, tech-enabled startups across Africa.",
        image_url: "images-events/Funding_Access.original.jpg",
        cta_text: "Request Mentorship",
        cta_link: "/founder_onboarding",
        secondary_cta: {
          label: "Become a Mentor",
          link: "/mentor_onboarding"
        }
      }.freeze

    def impact_network
      # @logos available for management; preview will use active logos
      @preview_logos = Logo.where(active: true).order(:display_order)
    end

    def hero
        @hero_content = hero_content_hash
        @hero_slides = hero_slides_from_json(@hero_content)
        @hero_secondary_cta = (@hero_content[:secondary_cta].is_a?(Hash) ? @hero_content[:secondary_cta] : {}).with_indifferent_access
        @preview_hero = @hero_slides.first
    end

      def update_hero
        @hero_content = hero_params_with_defaults
        @home_content_json[:hero] = @hero_content.except(:slides)
        if @home_page.update(structured_content: @home_content_json.to_json)
          redirect_to admin_homepage_hero_path, notice: "Hero updated"
        else
          flash.now[:alert] = "Unable to save hero"
          @hero_slides = hero_slides_from_json(@hero_content)
          @hero_secondary_cta = (@hero_content[:secondary_cta].is_a?(Hash) ? @hero_content[:secondary_cta] : {}).with_indifferent_access
          render :hero, status: :unprocessable_entity
        end
      end

    def focus_areas
      @focus_areas = FocusArea.order(:display_order)
      @preview_focus_areas = @focus_areas.where(active: true)
      respond_to do |format|
        format.html { render template: "admin/homepage/focus_areas/index" }
        format.json { render json: { focus_areas: @focus_areas } }
      end
    end

    def cta
        @home_content_json ||= {}.with_indifferent_access
      @bottom_cta = bottom_cta_content
    end

    def update_cta
        @home_content_json ||= {}.with_indifferent_access
      @home_content_json[:bottom_cta] = bottom_cta_params
      if @home_page.update(structured_content: @home_content_json.to_json)
        redirect_to admin_homepage_cta_path, notice: "CTA updated"
      else
        @bottom_cta = bottom_cta_content
        flash.now[:alert] = "Unable to save CTA"
        render :cta
      end
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

    def prepare_home_content
      set_homepage
      raw_content = @home_page.structured_content
      @home_content_json = case raw_content
      when Hash then raw_content.with_indifferent_access
      when String
        begin
          JSON.parse(raw_content).with_indifferent_access
        rescue JSON::ParserError
          {}
        end
      else
        {}
      end.with_indifferent_access
    end

    def hero_content_hash
      hero_json = @home_content_json[:hero]
      hero_attrs = hero_json.is_a?(Hash) ? hero_json.with_indifferent_access : {}.with_indifferent_access
      HERO_DEFAULT.deep_merge(hero_attrs)
    end

    def hero_params_with_defaults
      payload = hero_params.to_h.with_indifferent_access
      if payload[:secondary_cta].is_a?(Hash)
        payload[:secondary_cta] = payload[:secondary_cta].with_indifferent_access
      end
      HERO_DEFAULT.deep_merge(payload)
    end

    def hero_slides_from_json(hero_json)
      slides = hero_json[:slides].presence || hero_json[:slide].presence
      slides = Array.wrap(slides) if slides.present?
      if slides.blank? && hero_json[:title].present?
        slides = [ hero_json.slice(:title, :subtitle, :image_url, :cta_text, :cta_link) ]
      end
      return [] unless slides.present?
      slides.map do |attrs|
        OpenStruct.new(attrs.with_indifferent_access)
      end
    end

    def hero_params
      params.require(:hero).permit(:title, :subtitle, :image_url, :cta_text, :cta_link, secondary_cta: %i[label link])
    end

    def bottom_cta_content
      default = PagesController::DEFAULT_BOTTOM_CTA.deep_dup.with_indifferent_access
      existing = @home_content_json[:bottom_cta].presence || {}
      default.deep_merge(existing).with_indifferent_access
    end

    def bottom_cta_params
      params.require(:bottom_cta).permit(
        :heading,
        :body,
        primary_cta: %i[label link],
        secondary_cta: %i[label link]
      ).to_h.with_indifferent_access
    end

    def set_logos
      @logos = Logo.order(:display_order)
    end

    def set_homepage
      @home_page = HomePage.first_or_initialize
    end
  end
end
