class Program < ApplicationRecord
    before_validation :set_slug, on: :create
    validates :slug, presence: true, uniqueness: true

    # Program categories (keeps in sync with PagesController::PROGRAM_CATEGORIES)
    CATEGORIES = (defined?(PagesController) && PagesController.const_defined?(:PROGRAM_CATEGORIES)) ? PagesController::PROGRAM_CATEGORIES : [
      "Startup Incubation & Acceleration",
      "Masterclasses & Mentorship",
      "Funding Access",
      "Research & Development",
      "Social Impact Programs"
    ].freeze

    validates :category, inclusion: { in: CATEGORIES }, allow_blank: true

    def category
      program_type.presence
    end

    def category=(_value)
      # intentionally ignore leftover category assignments; program_type is the canonical field
    end

    # Associations for multi-category support (optional)
    has_and_belongs_to_many :categories, join_table: :categories_programs, optional: true

    # Return the primary image to use for cards/hero: prefer cover_image_url, then first inline image
    def primary_image_url
      cover_image_url.presence || (inline_image_urls.is_a?(Array) ? inline_image_urls.first : nil) || "https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?w=1200"
    end

    # All available inline images (array)
    def image_urls
      inline_image_urls.is_a?(Array) ? inline_image_urls : (cover_image_url.present? ? [ cover_image_url ] : [])
    end

    def to_param
      slug.presence || super
    end

    private

    def set_slug
      self.slug ||= (title || id.to_s).parameterize if slug.blank?
    end
  def rails_admin_preview_path
    helpers = Rails.application.routes.url_helpers
    if slug.present?
      helpers.program_detail_path(slug)
    else
      helpers.programs_path
    end
  rescue StandardError
    "/programs"
  end
end
