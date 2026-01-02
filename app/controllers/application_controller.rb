
  class ApplicationController < ActionController::Base
    helper AdminDashboardHelper
    before_action :redirect_to_onboarding_if_needed, unless: :devise_controller?
    before_action :store_return_to, if: :devise_controller?
    protect_from_forgery with: :exception

    private

    def redirect_to_onboarding_if_needed
      return if devise_controller?
      return unless user_signed_in?
      return if request.path == founder_onboarding_path || request.path.start_with?("/api")
      user_profile = current_user.user_profile
      unless user_profile&.onboarding_completed?
        redirect_to founder_onboarding_path unless request.path == founder_onboarding_path
      end
    end

    def store_return_to
      if params[:return_to].present? && (params[:action] == "new" || params[:action] == "create")
        session[:user_return_to] = params[:return_to]
      end
    end

    protected

    def after_sign_up_path_for(resource)
      session.delete(:user_return_to) || stored_location_for(resource) || founder_root_path
    end

    def after_sign_in_path_for(resource)
      session.delete(:user_return_to) || stored_location_for(resource) || founder_root_path
    end

    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
  end
