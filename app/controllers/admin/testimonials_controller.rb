module Admin
  class TestimonialsController < RailsAdmin::MainController
    before_action :set_testimonial, only: [ :edit, :update, :destroy ]

    def index
      @testimonials = Testimonial.all.order(:display_order)
      respond_to do |format|
        format.html { render template: "admin/homepage/testimonials/index" }
        format.json { render json: { testimonials: @testimonials } }
      end
    end

    def new
      @testimonial = Testimonial.new
    end

    def create
      # separate file attachment from mass-assigned params
      attach_io = testimonial_params.delete(:photo)
      @testimonial = Testimonial.new(testimonial_params)
      if @testimonial.save
        @testimonial.photo.attach(attach_io) if attach_io.present?
        respond_to do |format|
          format.html { redirect_to admin_testimonials_path, notice: "Testimonial created" }
          format.json do
            render json: {
              html_rows: render_to_string(partial: "admin/homepage/testimonials/rows", formats: [ :html ], locals: { testimonials: Testimonial.all.order(:display_order) }),
                preview_html: render_to_string(partial: "admin/homepage/testimonials/preview", formats: [ :html ], locals: { testimonials: Testimonial.where(active: true).order(:display_order) })
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
      attach_io = testimonial_params.delete(:photo)
      if @testimonial.update(testimonial_params)
        if attach_io.present?
          @testimonial.photo.purge if @testimonial.photo.attached?
          @testimonial.photo.attach(attach_io)
        end
        respond_to do |format|
          format.html { redirect_to admin_testimonials_path, notice: "Testimonial updated" }
          format.json do
            render json: {
              html_rows: render_to_string(partial: "admin/homepage/testimonials/rows", formats: [ :html ], locals: { testimonials: Testimonial.all.order(:display_order) }),
                preview_html: render_to_string(partial: "admin/homepage/testimonials/preview", formats: [ :html ], locals: { testimonials: Testimonial.where(active: true).order(:display_order) })
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
      params.require(:testimonial).permit(:author_name, :quote, :author_role, :organization, :photo_url, :website_url, :display_order, :active, :photo)
    end
  end
end
