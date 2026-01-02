module Api
  module V1
    module Serializers
      class MentorshipRequestSerializer
        def initialize(request)
          @request = request
        end

        def to_h
          {
            id: request.id,
            message: request.message,
            status: request.status,
            created_at: request.created_at,
            responded_at: request.responded_at,
            founder: user_payload(request.founder, %i[full_name photo_url bio location]),
            mentor: user_payload(request.mentor, %i[full_name photo_url title organization location]),
            startup_profile: startup_payload(request.founder&.startup_profile)
          }
        end

        private

        attr_reader :request

        def user_payload(user, fields)
          profile = user&.user_profile
          return nil unless profile

          fields.each_with_object({}) do |field, memo|
            memo[field] = profile.send(field)
          end
        end

        def startup_payload(startup)
          return nil unless startup

          {
            startup_name: startup.startup_name,
            sector: startup.sector,
            stage: startup.stage,
            description: startup.description
          }
        end
      end
    end
  end
end
