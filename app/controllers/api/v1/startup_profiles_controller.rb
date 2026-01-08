module Api
  module V1
    class StartupProfilesController < PublicController
      def index
        startups = StartupProfile.where(active: true)
        startups = startups.where(sector: params[:sector]) if params[:sector].present?
        startups = startups.where(stage: params[:stage]) if params[:stage].present?
        if params[:location].present?
          startups = startups.where("location ILIKE ?", "%#{CGI.escapeHTML(params[:location])}%")
        end
        if params[:search].present?
          search_term = "%#{params[:search]}%"
          startups = startups.where("startup_name ILIKE ? OR description ILIKE ?", search_term, search_term)
        end
        startups = startups.includes(user: :user_profile).order(created_at: :desc)
        render_collection(startups, Serializers::StartupProfileSerializer)
      end
    end
  end
end
