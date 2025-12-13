class TemplateGuidesController < ApplicationController
  before_action :set_template_guide, only: %i[ show edit update destroy ]

  # GET /template_guides or /template_guides.json
  def index
    @template_guides = TemplateGuide.all
  end

  # GET /template_guides/1 or /template_guides/1.json
  def show
  end

  # GET /template_guides/new
  def new
    @template_guide = TemplateGuide.new
  end

  # GET /template_guides/1/edit
  def edit
  end

  # POST /template_guides or /template_guides.json
  def create
    @template_guide = TemplateGuide.new(template_guide_params)

    respond_to do |format|
      if @template_guide.save
        format.html { redirect_to @template_guide, notice: "Template guide was successfully created." }
        format.json { render :show, status: :created, location: @template_guide }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @template_guide.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /template_guides/1 or /template_guides/1.json
  def update
    respond_to do |format|
      if @template_guide.update(template_guide_params)
        format.html { redirect_to @template_guide, notice: "Template guide was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @template_guide }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @template_guide.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /template_guides/1 or /template_guides/1.json
  def destroy
    @template_guide.destroy!

    respond_to do |format|
      format.html { redirect_to template_guides_path, notice: "Template guide was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template_guide
      @template_guide = TemplateGuide.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def template_guide_params
      params.expect(template_guide: [ :title, :category ])
    end
end
