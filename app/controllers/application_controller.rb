
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper AdminDashboardHelper
  before_action :redirect_to_onboarding_if_needed, unless: :devise_controller?
  before_action :store_return_to, if: :devise_controller?
  protect_from_forgery with: :exception

    private

    def redirect_to_onboarding_if_needed
      return if devise_controller?
      return unless user_signed_in?
      return if request.path == founder_onboarding_path || request.path == mentor_onboarding_path || request.path.start_with?("/api")
      return if request.path.in?([ "/programs", "/resources", "/startups", "/mentors", "/pricing", "/contact", "/about" ])
      return if request.path == "/"
      user_profile = current_user.user_profile
      unless user_profile&.onboarding_completed?
        onboarding_path = case user_profile&.role
        when "mentor"
          mentor_onboarding_path
        else
          founder_onboarding_path
        end
        redirect_to onboarding_path unless request.path == onboarding_path
      end
    end

    def store_return_to
      if params[:return_to].present? && (params[:action] == "new" || params[:action] == "create")
        session[:user_return_to] = params[:return_to]
      end
    end

    protected

    def after_sign_up_path_for(resource)
      session.delete(:user_return_to) || stored_location_for(resource) || begin
        case resource.user_profile&.role
        when "mentor"
          mentor_root_path
        when "partner"
          founder_root_path
        else
          founder_root_path
        end
      end
    end

    def after_sign_in_path_for(resource)
      session.delete(:user_return_to) || stored_location_for(resource) || begin
        case resource.user_profile&.role
        when "mentor"
          mentor_root_path
        when "partner"
          # For now, redirect partners to founder dashboard or implement partner dashboard
          founder_root_path
        else
          founder_root_path
        end
      end
    end

    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
end
