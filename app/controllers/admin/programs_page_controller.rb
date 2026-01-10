module Admin
  class ProgramsPageController < RailsAdmin::MainController
    # GET /admin/programs_page/:id/edit
    def edit
      @programs_page = if params[:id].present?
        ::ProgramsPage.find_by(id: params[:id])
      end
      @programs_page ||= ::ProgramsPage.first_or_create!(title: "Programs")

      # parse stored content (free-form JSON or raw HTML)
      @stored = parse_programs_page_content(@programs_page)
      # Note: current programs list is not loaded in this editor view
    end

    # NOTE: `new` and `create` actions removed — editing is done via the edit page only.

    # PATCH /admin/programs_page/:id
    def update
      @programs_page = if params[:id].present?
        ::ProgramsPage.find_by(id: params[:id])
      end
      @programs_page ||= ::ProgramsPage.first_or_create!(title: "Programs")

      # Support simple title/content update and structured payload
      if params[:programs_page].present?
        begin
          @programs_page.update!(params.require(:programs_page).permit(:title, :content))
        rescue => e
          Rails.logger.info("[Admin::ProgramsPage] update failed: #{e.message}")
        end
      elsif params[:programs_page_payload].present?
        payload = params.require(:programs_page_payload).permit!.to_h
        @programs_page.update!(content: payload.to_json)
      end

      redirect_to edit_admin_programs_page_path(@programs_page), notice: "Programs page saved"
    end

    private

    def parse_programs_page_content(page)
      # Prefer `intro` ActionText content; fall back to legacy `content` if present
      return {} unless page.present?
      if page.respond_to?(:intro) && page.intro.respond_to?(:body) && page.intro.body.present?
        return { "intro_html" => page.intro.body.to_s }
      elsif page.respond_to?(:content) && page.content.present?
        if page.content.respond_to?(:body)
          return { "content_html" => page.content.body.to_s }
        end
        return JSON.parse(page.content) rescue { "content_html" => page.content.to_s }
      end
      {}
    end

    def programs_page_params
      params.require(:programs_page).permit(:title, :intro_title, :intro, :content)
    end
  end
end
