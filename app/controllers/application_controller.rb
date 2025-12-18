
	class ApplicationController < ActionController::Base
		before_action :redirect_to_onboarding_if_needed
		protect_from_forgery with: :exception

		private

		def redirect_to_onboarding_if_needed
			return unless user_signed_in?
			return if request.path == founder_onboarding_path || request.path.start_with?('/api')
			user_profile = current_user.user_profile
			unless user_profile&.onboarding_completed?
				redirect_to founder_onboarding_path unless request.path == founder_onboarding_path
			end
		end

		protected

		def after_sign_up_path_for(resource)
			founder_root_path
		end

		def after_sign_in_path_for(resource)
			founder_root_path
		end

		def after_sign_out_path_for(resource_or_scope)
			root_path
		end
	end
