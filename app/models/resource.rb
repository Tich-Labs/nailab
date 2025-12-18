class Resource < ApplicationRecord
	def slug
		title.parameterize
	end

	def rails_admin_preview_path
		helpers = Rails.application.routes.url_helpers
		if slug.present?
			helpers.resource_detail_path(slug)
		else
			helpers.resources_path
		end
	rescue StandardError
		'/resources'
	end
end
