module Api
  module V1
    module Serializers
      class HeroSlideSerializer
        def initialize(hero_slide)
          @hero_slide = hero_slide
        end

        def to_h
          {
            id: hero_slide.id,
            title: hero_slide.title,
            subtitle: hero_slide.subtitle,
            image_url: hero_slide.image_url,
            cta_text: hero_slide.cta_text,
            cta_link: hero_slide.cta_link,
            display_order: hero_slide.display_order
          }
        end

        private

        attr_reader :hero_slide
      end
    end
  end
end
