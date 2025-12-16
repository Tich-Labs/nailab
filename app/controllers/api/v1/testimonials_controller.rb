module Api
  module V1
    class TestimonialsController < PublicController
      def index
        testimonials = Testimonial.where(active: true).order(:display_order, created_at: :desc)
        render_collection(testimonials, Serializers::TestimonialSerializer)
      end
    end
  end
end
