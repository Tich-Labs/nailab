class StartupsController < ApplicationController
  # GET /startups or /startups.json
  def index
    @startups = scoped_startups

    # Apply filters
    @startups = @startups.where(startup_stage: params[:startup_stage]) if params[:startup_stage].present?
    @startups = @startups.where(startup_industry: params[:startup_industry]) if params[:startup_industry].present?
    @startups = @startups.where(request_type: params[:request_type]) if params[:request_type].present?

    # Apply search
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @startups = @startups.where("startup_name ILIKE ? OR full_name ILIKE ?", search_term, search_term)
    end

    @startups = @startups.page(params[:page]).per(12)
  end

  # GET /startups/1 or /startups/1.json
  def show
    @startup = scoped_startups.find(params[:id])
  end

  private

  def scoped_startups
    MentorshipRequest.where(status: :approved)
                     .where.not(startup_name: nil)
                     .includes(:user)
                     .order(created_at: :desc)
  end
end
