module Api
  module V1
    class ProgramsController < PublicController
      def index
        programs = Program.where(active: true)
        programs = programs.where(category: params[:category]) if params[:category].present?
        programs = programs.order(created_at: :desc)
        render_collection(programs, Serializers::ProgramSerializer)
      end

      def show
        program = Program.find_by!(slug: params[:slug], active: true)
        render_resource(program, Serializers::ProgramSerializer)
      end
    end
  end
end
