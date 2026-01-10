module Admin
  class ProgramsController < RailsAdmin::MainController
    protect_from_forgery with: :exception

    def create
      @program = Program.new(program_params)
      if @program.save
        render json: program_json(@program), status: :created
      else
        render json: { errors: @program.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def program_params
      params.require(:program).permit(:title, :short_summary, :description, :cover_image_url, :start_date, category_ids: [])
    end

    def program_json(p)
      {
        id: p.id,
        title: p.title,
        categories: p.categories.map(&:name),
        short_summary: p.short_summary.to_s,
        description: p.description.to_s,
        cover_image_url: p.cover_image_url.to_s,
        start_date: p.start_date
      }
    end
  end
end
