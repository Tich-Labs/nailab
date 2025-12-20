module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def show
        render json: current_user.slice(:id, :email, :created_at, :updated_at)
      end
    end
  end
end