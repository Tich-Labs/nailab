module Admin
  class LogosController < RailsAdmin::MainController
    before_action :set_logo, only: [ :destroy, :update, :edit ]

    def index
      @logos = Logo.all
    end

    def new
      @logo = Logo.new
    end

    def create
      @logo = Logo.new(logo_params)
      if @logo.save
        respond_to do |format|
          format.html { redirect_to admin_homepage_impact_network_path, notice: "Logo uploaded" }
          format.json do
            render json: {
              html_rows: render_to_string(partial: "admin/homepage/impact_network_rows", formats: [ :html ], locals: { logos: Logo.all.order(:display_order) }),
              preview_html: render_to_string(partial: "admin/homepage/impact_network_preview", formats: [ :html ], locals: { logos: Logo.where(active: true).order(:display_order) })
            }
          end
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = @logo.errors.full_messages.to_sentence
            render :new, status: :unprocessable_entity
          end
          format.json { render json: { errors: @logo.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    def edit
      # handled via inline editor on impact_network page
      redirect_to admin_homepage_impact_network_path(anchor: "editor")
    end

    def update
      if @logo.update(logo_params)
        respond_to do |format|
          format.html { redirect_to admin_homepage_impact_network_path, notice: "Logo updated" }
          format.json do
            render json: {
              html_rows: render_to_string(partial: "admin/homepage/impact_network_rows", formats: [ :html ], locals: { logos: Logo.all.order(:display_order) }),
              preview_html: render_to_string(partial: "admin/homepage/impact_network_preview", formats: [ :html ], locals: { logos: Logo.where(active: true).order(:display_order) })
            }
          end
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = @logo.errors.full_messages.to_sentence
            render :new, status: :unprocessable_entity
          end
          format.json { render json: { errors: @logo.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @logo.destroy
      redirect_to admin_homepage_impact_network_path, notice: "Logo removed"
    end

    private

    def set_logo
      @logo = Logo.find(params[:id])
    end

    def logo_params
      params.require(:logo).permit(:name, :display_order, :active, :image)
    end
  end
end
