class Program < ApplicationRecord
		before_validation :set_slug, on: :create
		validates :slug, presence: true, uniqueness: true

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
		'/programs'
	end
end
