class Resource < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_one_attached :hero_image
  has_many_attached :inline_images
  has_many :ratings, dependent: :destroy

  enum :tier, { free: 0, premium: 1 }

  before_validation :set_slug, on: :create
  validates :slug, presence: true, uniqueness: true
  validates :title, presence: true
  validate :rating_count_integrity

  scope :free_resources, -> { where(tier: :free) }
  scope :premium_resources, -> { where(tier: :premium) }
  scope :by_type, ->(type) { where(resource_type: type) if type.present? }
  scope :by_tier, ->(tier_name) { where(tier: tier_name) if tier_name.present? }
  scope :searchable, ->(query) { where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%") if query.present? }

  def to_param
    slug.presence || super
  end

  # Access control methods
  def accessible_by?(user)
    return true if free?
    return false unless user
    user.subscription&.can_access_resources? || false
  end

  def access_denied_message
    "#{title} is a premium resource. Upgrade your subscription to continue access."
  end

  def is_free?
    tier == :free || tier == "free"
  end

  def is_premium?
    tier == :premium || tier == "premium"
  end

  # Rating aggregation
  def average_rating
    return 0 if ratings.empty?
    (ratings.sum(:score).to_f / ratings.count).round(2)
  end

  def rating_count
    ratings.count
  end

  def has_ratings?
    ratings.any?
  end

  # Primary action for resource (DRY principle - not in view)
  def primary_action_label
    resource_type_to_action[resource_type.to_s.downcase] || "Download"
  end

  def primary_action_path(route_helpers = nil)
    case resource_type.to_s.downcase
    when "blog", "article"
      url.presence || "#"
    when "template", "guide"
      url.presence || "#"
    else
      url.presence || "#"
    end
  end

  def resource_type_to_action
    {
      "blog" => "Read",
      "article" => "Read",
      "template" => "Download",
      "guide" => "Download",
      "opportunity" => "Apply",
      "event" => "Attend",
      "webinar" => "Register",
      "case_study" => "Read"
    }
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

  def rating_count_integrity
    # Validate that rating count is consistent with actual ratings
    return unless ratings.any?
    if rating_count < 0
      errors.add(:ratings, "count cannot be negative")
    end
  end
end
