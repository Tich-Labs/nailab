class Resource < ApplicationRecord
  has_many :ratings
  has_many :bookmarks
  has_many :users, through: :bookmarks
  def slug
    title.parameterize
  end

  def file_type
    case resource_type
    when "blog"
      "Article"
    when "event"
      "Event"
    when "webinar"
      "Webinar"
    when "opportunity"
      "Opportunity"
    when "template"
      "Template"
    when "guide"
      "Guide"
    when "pdf"
      "PDF"
    when "video"
      "Video"
    else
      "Resource"
    end
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
