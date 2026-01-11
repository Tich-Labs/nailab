module Admin
  class UserProfilesController < ApplicationController
    # Authentication temporarily disabled for admin pages (development)
    before_action :set_profile, only: %i[show approve reject]

    def index
      @profiles = UserProfile.where(profile_approval_status: "pending").order(created_at: :asc)
    end

    def show
    end

    def approve
      @profile.approve!(actor: current_user)
      redirect_to admin_user_profiles_path, notice: "Profile approved."
    rescue => e
      redirect_to admin_user_profiles_path, alert: "Approval failed: #{e.message}"
    end

    def reject
      reason = params[:reason].presence || "No reason provided"
      @profile.reject!(reason: reason, actor: current_user)
      redirect_to admin_user_profiles_path, notice: "Profile rejected."
    rescue => e
      redirect_to admin_user_profiles_path, alert: "Rejection failed: #{e.message}"
    end

    private

    def set_profile
      @profile = UserProfile.find(params[:id])
    end

  end
end
