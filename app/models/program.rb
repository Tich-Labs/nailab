class Program < ApplicationRecord
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
