module Admin
  class AboutSectionsController < ApplicationController
  before_action :set_about_section, only: %i[ show edit update destroy ]

  # GET /about_sections
  def index
    @about_sections = AboutSection.all
  end

  # GET /about_sections/1
  def show
  end

  # GET /about_sections/new
  def new
    @about_section = AboutSection.new
  end

  # GET /about_sections/1/edit
  def edit
  end

  # POST /about_sections
  def create
    @about_section = AboutSection.new(about_section_params)

    if @about_section.save
      redirect_to @about_section, notice: "About section was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /about_sections/1
  def update
    if @about_section.update(about_section_params)
      redirect_to @about_section, notice: "About section was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /about_sections/1
  def destroy
    @about_section.destroy!
    redirect_to about_sections_path, notice: "About section was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_about_section
      @about_section = AboutSection.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def about_section_params
      params.expect(about_section: [ :title, :section_type, :content ])
    end
  end
end
## This controller is obsolete. Use app/controllers/admin/about_sections_controller.rb for AboutSection admin CRUD.
