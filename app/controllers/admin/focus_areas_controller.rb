module Admin
  class FocusAreasController < RailsAdmin::MainController
    before_action :set_focus_area, only: %i[edit update destroy reorder toggle]

    def index
      @focus_areas = FocusArea.order(:display_order)
      @preview_focus_areas = @focus_areas.where(active: true)
      @focus_area = FocusArea.new

      respond_to do |format|
        format.html { render template: "admin/homepage/focus_areas/index" }
        format.json do
          render json: {
            html_rows: render_to_string(partial: "admin/homepage/focus_areas/rows", formats: [ :html ], locals: { focus_areas: @focus_areas }),
            preview_html: render_to_string(partial: "admin/homepage/focus_areas/preview", formats: [ :html ], locals: { focus_areas: [] })
          }
        end
      end
    end

    def new
      @focus_area = FocusArea.new
    end

    def create
      @focus_area = FocusArea.new(focus_area_params)
      @focus_area.display_order ||= (FocusArea.maximum(:display_order) || 0) + 1
      if @focus_area.save
        respond_to do |format|
          format.html { redirect_to admin_focus_areas_path(anchor: "editor"), notice: "Focus area created" }
          format.json do
            render json: {
              html_rows: render_to_string(partial: "admin/homepage/focus_areas/rows", formats: [ :html ], locals: { focus_areas: FocusArea.order(:display_order) }),
                preview_html: render_to_string(partial: "admin/homepage/focus_areas/preview", formats: [ :html ], locals: { focus_areas: [] })
            }
          end
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.json { render json: { errors: @focus_area.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    def edit
    end

    def update
      if @focus_area.update(focus_area_params)
        respond_to do |format|
          format.html { redirect_to admin_focus_areas_path(anchor: "editor"), notice: "Focus area updated" }
          format.json do
            render json: {
              html_rows: render_to_string(partial: "admin/homepage/focus_areas/rows", formats: [ :html ], locals: { focus_areas: FocusArea.order(:display_order) }),
                preview_html: render_to_string(partial: "admin/homepage/focus_areas/preview", formats: [ :html ], locals: { focus_areas: [] })
            }
          end
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.json { render json: { errors: @focus_area.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @focus_area.destroy
      redirect_to admin_focus_areas_path, notice: "Focus area deleted"
    end

    def reorder
      direction = params[:direction]
      if direction == "up"
        swap_with = FocusArea.where("display_order < ?", @focus_area.display_order).order(display_order: :desc).first
      else
        swap_with = FocusArea.where("display_order > ?", @focus_area.display_order).order(display_order: :asc).first
      end

      if swap_with
        @focus_area.display_order, swap_with.display_order = swap_with.display_order, @focus_area.display_order
        @focus_area.save
        swap_with.save
      end

      redirect_to admin_focus_areas_path, notice: "Order updated"
    end

    def toggle
      @focus_area.update(active: !@focus_area.active)
      redirect_to admin_focus_areas_path, notice: "Status updated"
    end

    private

    def set_focus_area
      @focus_area = FocusArea.find_by(id: params[:id])
      redirect_to admin_focus_areas_path, alert: "Not found" if @focus_area.nil?
    end

    def focus_area_params
      params.require(:focus_area).permit(:title, :description, :icon, :active)
    end
  end
end
