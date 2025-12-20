module Api
  module V1
    class MentorProfilesController < PublicController
      def index
        mentors = UserProfile.where(role: 'mentor', profile_visibility: true, onboarding_completed: true)
        mentors = mentors.where("sectors @> ?", Array(params[:sector]).to_json) if params[:sector].present?
        Array(params[:expertise]).each do |expertise|
          next if expertise.blank?
          mentors = mentors.where("expertise @> ?", [expertise].to_json)
        end
        if params[:stage].present?
          mentors = mentors.where("stage_preference @> ?", [params[:stage]].to_json)
        end
        if params[:location].present?
          mentors = mentors.where('location ILIKE ?', "%#{params[:location]}%")
        end
        if params[:pro_bono].present?
          mentors = mentors.where(pro_bono: params[:pro_bono] == 'pro_bono')
        end

        mentors = mentors.includes(:user).order(created_at: :desc)
        render_collection(mentors, Serializers::MentorProfileSerializer)
      end
    end
  end
end