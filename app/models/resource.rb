class Resource < ApplicationRecord
  has_one_attached :hero_image
  has_many_attached :inline_images
  has_many :ratings, dependent: :destroy
  before_validation :set_slug, on: :create
  validates :slug, presence: true, uniqueness: true

  def to_param
    slug.presence || super
  end

  # Friendly label used in listing cards. Historically views referenced
  # `category` and `file_type`; provide simple fallbacks based on
  # `resource_type` so templates don't raise NoMethodError.
  def category
    resource_type.present? ? resource_type.titleize : "Resource"
  end

  def file_type
    # For resources that are external links vs internal posts, try to
    # provide a short label. Defaults to a capitalized resource_type.
    resource_type.present? ? resource_type.capitalize : "Resource"
  end

  # Provide an `author` helper used by views. If the resource has a
  # remote `url`, prefer the host (e.g. example.com); otherwise return
  # an empty string to avoid NoMethodError in templates.
  def author
    return "" unless url.present?
    host = URI.parse(url).host
    host&.sub(/^www\./, "") || ""
  rescue URI::InvalidURIError
    ""
  end

  private

  def set_slug
    self.slug ||= (title || id.to_s).parameterize if slug.blank?
  end

  def rails_admin_preview_path
    helpers = Rails.application.routes.url_helpers
    if slug.present?
      helpers.resource_detail_path(slug)
    else
      helpers.resources_path
    end
  rescue StandardError
    "/resources"
  end
end
