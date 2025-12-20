module Api
  module V1
    module Serializers
      class MentorProfileSerializer
        def initialize(profile)
          @profile = profile
        end

        def to_h
          {
            id: profile.user_id,
            profile_id: profile.id,
            full_name: profile.full_name,
            bio: profile.bio,
            title: profile.title,
            organization: profile.organization,
            location: profile.location,
            photo_url: profile.photo_url,
            linkedin_url: profile.linkedin_url,
            years_experience: profile.years_experience,
            advisory_experience: profile.advisory_experience,
            sectors: profile.sectors || [],
            expertise: profile.expertise || [],
            stage_preference: profile.stage_preference || [],
            availability_hours_month: profile.availability_hours_month,
            rate_per_hour: profile.rate_per_hour&.to_f,
            pro_bono: profile.pro_bono,
            preferred_mentorship_mode: profile.preferred_mentorship_mode,
            profile_visibility: profile.profile_visibility,
            onboarding_completed: profile.onboarding_completed
          }
        end

        private

        attr_reader :profile
      end
    end
  end
end
