module Founder
  class StartupsController < ApplicationController
    layout "founder_dashboard"
    before_action :ensure_signed_in
    before_action :validate_multiple_startups, only: [ :new, :create ]

    def new
      @startup = Startup.new
      @stage_options = StartupProfile::STAGE_OPTIONS
      @sector_options = StartupProfile::SECTOR_OPTIONS
    end

    def create
      @startup = current_user.startups.build(startup_params)

      respond_to do |format|
        if @startup.save
          format.html do
            redirect_to founder_startup_profile_path,
                        notice: "Startup added successfully. You are automatically added as owner, and can invite team members from the profile."
          end
          format.json do
            render json: {
              success: true,
              startup: @startup.as_json(only: %i[id name website_url description]),
              team_initialized: @startup.team_initialized?
            }, status: :created
          end
        else
          @stage_options = StartupProfile::STAGE_OPTIONS
          @sector_options = StartupProfile::SECTOR_OPTIONS

          format.html do
            flash.now[:alert] = "There were errors creating the startup."
            render :new, status: :unprocessable_entity
          end
          format.json do
            render json: {
              success: false,
              errors: @startup.errors.full_messages
            }, status: :unprocessable_entity
          end
        end
      end
    end

    private

    def validate_multiple_startups
      # Optional: limit number of startups per founder
      # This is a policy decision - adjust as needed
      if current_user.startups.count >= 10
        redirect_to founder_startup_profile_path,
                    alert: "You have reached the maximum number of startups. Please contact support for more."
      end
    end

    def startup_params
      params.require(:startup).permit(
        :name,
        :description,
        :website_url,
        :founded_year,
        :team_size,
        :value_proposition,
        :target_market,
        :location,
        :sector,
        :stage,
        :logo
      )
    end
  end
end
