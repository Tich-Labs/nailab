module Admin
  class TestimonialsController < RailsAdmin::MainController
    before_action :set_testimonial, only: [ :edit, :update, :destroy ]

    def index
      @testimonials = Testimonial.all.order(:display_order)
    end

    def new
      @testimonial = Testimonial.new
    end

    def create
      @testimonial = Testimonial.new(testimonial_params)
      if @testimonial.save
        respond_to do |format|
          format.html { redirect_to admin_testimonials_path, notice: "Testimonial created" }
          format.json do
            render json: {
              html_rows: render_to_string(partial: "admin/testimonials/rows", formats: [ :html ], locals: { testimonials: Testimonial.all.order(:display_order) }),
              preview_html: render_to_string(partial: "admin/testimonials/preview", formats: [ :html ], locals: { testimonials: Testimonial.where(active: true).order(:display_order) })
            }
          end
        end
      else
        respond_to do |format|
          format.html { flash.now[:alert] = @testimonial.errors.full_messages.to_sentence; render :new, status: :unprocessable_entity }
          format.json { render json: { errors: @testimonial.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    def edit
      redirect_to admin_testimonials_path(anchor: "editor")
    end

    def update
      if @testimonial.update(testimonial_params)
        respond_to do |format|
          format.html { redirect_to admin_testimonials_path, notice: "Testimonial updated" }
          format.json do
            render json: {
              html_rows: render_to_string(partial: "admin/testimonials/rows", formats: [ :html ], locals: { testimonials: Testimonial.all.order(:display_order) }),
              preview_html: render_to_string(partial: "admin/testimonials/preview", formats: [ :html ], locals: { testimonials: Testimonial.where(active: true).order(:display_order) })
            }
          end
        end
      else
        respond_to do |format|
          format.html { flash.now[:alert] = @testimonial.errors.full_messages.to_sentence; render :new, status: :unprocessable_entity }
          format.json { render json: { errors: @testimonial.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @testimonial.destroy
      redirect_to admin_testimonials_path, notice: "Testimonial removed"
    end

    private

    def set_testimonial
      @testimonial = Testimonial.find(params[:id])
    end

    def testimonial_params
      params.require(:testimonial).permit(:author_name, :quote, :author_role, :organization, :photo_url, :website_url, :display_order, :active)
    end
  end
end
