module Api
  module V1
    class OnboardingController < PublicController
      def founder
        user = User.find_by(id: params[:user_id])
        return render json: { error: "User not found" }, status: :not_found unless user

        profile = user.user_profile || user.build_user_profile
        profile.assign_attributes(founder_profile_params.merge(
          role: "founder",
          onboarding_completed: true,
          profile_visibility: true
        ))
        profile.save!

        startup = user.startup_profile || user.build_startup_profile
        startup.assign_attributes(startup_profile_params)
        startup.funding_raised = startup_profile_params[:funding_raised].to_f if startup_profile_params[:funding_raised].present?
        startup.mentorship_areas = startup_profile_params[:mentorship_areas] || []
        startup.save!

        render json: { success: true }
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      def mentor
        user = User.find_by(id: params[:user_id])
        return render json: { error: "User not found" }, status: :not_found unless user

        profile = user.user_profile || user.build_user_profile
        profile.assign_attributes(mentor_profile_params.merge(
          role: "mentor",
          onboarding_completed: true,
          profile_visibility: true
        ))
        profile.save!

        render json: { success: true }
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      private

      def founder_profile_params
        params.permit(:full_name, :bio, :location, :preferred_mentorship_mode, sectors: [])
      end

      def startup_profile_params
        params.fetch(:startup, {}).permit(
          :startup_name,
          :description,
          :sector,
          :stage,
          :location,
          :target_market,
          :value_proposition,
          :funding_stage,
          :funding_raised,
          :challenge_details,
          :preferred_mentorship_mode,
          :phone_number,
          :logo_url,
          :website_url,
          :founded_year,
          :team_size,
          mentorship_areas: []
        )
      end

      def mentor_profile_params
        params.permit(
          :full_name,
          :bio,
          :title,
          :organization,
          :linkedin_url,
          :years_experience,
          :advisory_experience,
          :availability_hours_month,
          :rate_per_hour,
          :preferred_mentorship_mode,
          :pro_bono,
          sectors: [],
          expertise: [],
          stage_preference: []
        )
      end
    end
  end
end
