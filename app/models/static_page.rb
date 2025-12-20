class StaticPage < ApplicationRecord
  RESERVED_SLUGS = %w[home about pricing contact].freeze

  validates :slug, presence: true, uniqueness: true
  validates :title, presence: true
  validate :slug_immutable_for_reserved_page, if: -> { persisted? && slug_changed? }

  attribute :structured_content, :jsonb, default: -> { {} }

  def rails_admin_preview_path
    helpers = Rails.application.routes.url_helpers
    case slug
    when "home"
      "/"
    when "about"
      helpers.about_path
    when "pricing"
      helpers.pricing_path
    when "contact"
      helpers.contact_path
    else
      "/"
    end
  end

  def reserved_slug?
    RESERVED_SLUGS.include?(slug)
  end

  private

  def slug_immutable_for_reserved_page
    return unless slug_was.present? && RESERVED_SLUGS.include?(slug_was)

    errors.add(:slug, "cannot be changed for reserved system pages")
  end
end
