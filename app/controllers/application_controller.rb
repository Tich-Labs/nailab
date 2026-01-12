
  class ApplicationController < ActionController::Base
    begin
      helper AdminDashboardHelper
    rescue NameError
      # AdminDashboardHelper not yet loaded during initialization; helper will be autoloaded when needed
    end
    before_action :redirect_to_onboarding_if_needed, unless: :devise_controller?
    before_action :store_return_to, if: :devise_controller?
    protect_from_forgery with: :exception

    private

    def redirect_to_onboarding_if_needed
      return if devise_controller?
      return unless user_signed_in?
      return if request.path.start_with?("/api")

      user_profile = current_user.user_profile
      return if user_profile&.onboarding_completed?

      target = onboarding_path_for(user_profile)
      redirect_to target unless request.path == target
    end

    def onboarding_path_for(user_profile)
      case user_profile&.role.to_s
      when "mentor"
        mentor_onboarding_path
      when "partner"
        partner_onboarding_path
      else
        founder_onboarding_path
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
      # Merge any guest onboarding data into the returning user's profiles
      begin
        Onboarding::SessionMerger.merge(resource, session)
      rescue => e
        Rails.logger.error("Onboarding session merge failed: #{e.message}")
      end

      session.delete(:user_return_to) || stored_location_for(resource) || begin
        case resource.user_profile&.role.to_s
        when "mentor"
          mentor_root_path
        when "partner"
          (defined?(partner_root_path) ? partner_root_path : founder_root_path)
        else
          founder_root_path
        end
      end
    end

    def after_sign_out_path_for(resource_or_scope)
      root_path
    end

    # Devise: ensure password reset redirects to a valid path (avoid polymorphic_url nil error)
    def after_sending_reset_password_instructions_path_for(resource_name)
      # Always redirect to the canonical sign-in page to avoid polymorphic URL build errors
      # (some callers may pass nil resource_name)
      if respond_to?(:new_user_session_path)
        new_user_session_path
      else
        root_path
      end
    end
  end
