module Api
  module V1
    module Serializers
      class StartupProfileSerializer
        def initialize(startup_profile)
          @startup_profile = startup_profile
        end

        def to_h
          {
            id: startup_profile.id,
            startup_name: startup_profile.startup_name,
            description: startup_profile.description,
            sector: startup_profile.sector,
            stage: startup_profile.stage,
            location: startup_profile.location,
            mentorship_areas: startup_profile.mentorship_areas,
            website_url: startup_profile.website_url,
            founded_year: startup_profile.founded_year,
            target_market: startup_profile.target_market,
            value_proposition: startup_profile.value_proposition,
            funding_stage: startup_profile.funding_stage,
            funding_raised: startup_profile.funding_raised&.to_f,
            challenge_details: startup_profile.challenge_details,
            preferred_mentorship_mode: startup_profile.preferred_mentorship_mode,
            phone_number: startup_profile.phone_number,
            logo_url: startup_profile.logo_url,
            team_size: startup_profile.team_size,
            founder: founder_payload,
            created_at: startup_profile.created_at
          }
        end

        private

        attr_reader :startup_profile

        def founder_payload
          profile = startup_profile.user&.user_profile
          return nil unless profile

          {
            full_name: profile.full_name,
            photo_url: profile.photo_url
          }
        end
      end
    end
  end
end
