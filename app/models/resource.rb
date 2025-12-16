class Resource < ApplicationRecord
	def slug
		title.parameterize
	end
end
