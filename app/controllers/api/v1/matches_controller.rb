module Api
  module V1
    class MatchesController < PublicController
      def index
        limit = params[:limit].present? ? params[:limit].to_i : 10
        matches = MatchingService.new(params[:founder_id], preferences: match_params.to_h).call(limit: limit)
        render json: matches
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      end
    end

    private

    def match_params
      params.permit(
        :industry,
        :stage,
        :preferred_cadence,
        :preferred_format,
        :time_zone,
        :program_tier,
        :timezone_flex_hours,
        languages: [],
        expertise_needs: [],
        do_not_match: [],
        availability_windows: %i[day start end]
      )
    end
  end
end
