class MentorsController < ApplicationController
  before_action :set_mentor, only: %i[ show edit update destroy ]

  # GET /mentors or /mentors.json
  def index
    @mentors = Mentor.where(approved: true).order(:created_at)
  end

  # GET /mentors/1 or /mentors/1.json
  def show
    @mentor = Mentor.find(params[:id])
  end

  # GET /mentors/new
  def new
    @mentor = Mentor.new
  end

  # GET /mentors/1/edit
  def edit
  end

  # POST /mentors or /mentors.json
  def create
    @mentor = Mentor.new(mentor_params)

    respond_to do |format|
      if @mentor.save
        format.html { redirect_to @mentor, notice: "Mentor was successfully created." }
        format.json { render :show, status: :created, location: @mentor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mentor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mentors/1 or /mentors/1.json
  def update
    respond_to do |format|
      if @mentor.update(mentor_params)
        format.html { redirect_to @mentor, notice: "Mentor was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @mentor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mentor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mentors/1 or /mentors/1.json
  def destroy
    @mentor.destroy!

    respond_to do |format|
      format.html { redirect_to mentors_path, notice: "Mentor was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mentor
      @mentor = Mentor.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def mentor_params
      params.expect(mentor: [ :name, :bio, :expertise, :email, :approved, :available,
                             :years_experience, :current_affiliation, :advisor_or_investor,
                             :mentorship_industries, :mentorship_areas, :preferred_stage,
                             :availability_hours_per_month, :mentorship_approach, :motivation,
                             :mentorship_mode, :hourly_rate, :linkedin_url, :website_url ])
    end
end
