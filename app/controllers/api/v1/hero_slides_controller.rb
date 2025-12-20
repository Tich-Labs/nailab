module Api
  module V1
    class HeroSlidesController < PublicController
      def index
        slides = HeroSlide.where(active: true).order(:display_order)
        render_collection(slides, Serializers::HeroSlideSerializer)
      end
    end
  end
end
