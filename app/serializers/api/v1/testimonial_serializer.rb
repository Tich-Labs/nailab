module Api
  module V1
    module Serializers
      class TestimonialSerializer
        def initialize(testimonial)
          @testimonial = testimonial
        end

        def to_h
          {
            id: testimonial.id,
            author_name: testimonial.author_name,
            author_role: testimonial.author_role,
            organization: testimonial.organization,
            quote: testimonial.quote,
            photo_url: testimonial.photo_url,
            rating: testimonial.rating,
            display_order: testimonial.display_order
          }
        end

        private

        attr_reader :testimonial
      end
    end
  end
end
