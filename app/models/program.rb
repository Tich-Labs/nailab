class Program < ApplicationRecord
  has_one_attached :image
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

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
