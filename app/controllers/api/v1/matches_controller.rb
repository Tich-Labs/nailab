module Api
  module V1
    class MatchesController < PublicController
      def index
        limit = params[:limit].present? ? params[:limit].to_i : 10
        matches = MatchingService.new(params[:founder_id]).call(limit: limit)
        render json: matches
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      end
    end
  end
end