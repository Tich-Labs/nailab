module Founder
  class StartupsController < ApplicationController
    before_action :ensure_signed_in
    before_action :ensure_founder_role

    def new
      @startup = Startup.new
    end

    def create
      @startup = current_user.startups.build(startup_params)
      respond_to do |format|
        if @startup.save
          format.html { redirect_to founder_startup_profile_path, notice: "Startup added successfully. You can invite team members from the profile." }
          format.json { render json: { success: true, startup: @startup.as_json(only: %i[id startup_name website_url description]) }, status: :created }
        else
          format.html do
            flash.now[:alert] = "There were errors creating the startup."
            render :new, status: :unprocessable_entity
          end
          format.json { render json: { success: false, errors: @startup.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    private

    def startup_params
      params.require(:startup).permit(:startup_name, :description, :website_url, :founded_year, :team_size, :value_proposition, :target_market, :location, :logo)
    end
  end
end
