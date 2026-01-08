module Admin
  class AboutSectionsController < ApplicationController
    before_action :set_about_section, only: %i[ show edit update destroy ]

    def index
      @about_sections = AboutSection.all
    end

    def show
    end

    def new
      @about_section = AboutSection.new
    end

    def edit
    end

    def create
      @about_section = AboutSection.new(about_section_params)
      if @about_section.save
        redirect_to [ :admin, @about_section ], notice: "About section was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @about_section.update(about_section_params)
        redirect_to [ :admin, @about_section ], notice: "About section was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @about_section.destroy!
      redirect_to admin_about_sections_path, notice: "About section was successfully destroyed.", status: :see_other
    end

    private
      def set_about_section
        @about_section = AboutSection.find(params[:id])
      end

      def about_section_params
        params.require(:about_section).permit(:title, :section_type, :content)
      end
  end
end
