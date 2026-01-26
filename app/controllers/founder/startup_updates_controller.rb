module Founder
  class StartupUpdatesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_startup

    def index
      @updates = @startup.startup_updates.order(report_year: :desc, report_month: :desc)
    end

    def new
      @startup_update = @startup.startup_updates.new
    end

    def create
      @startup_update = @startup.startup_updates.new(startup_update_params)
      if @startup_update.save
        flash[:notice] = "Update submitted successfully"
        redirect_to founder_startup_updates_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
    def set_startup
      @startup = current_user.startup
      return if @startup.present?

      redirect_to founder_startup_profile_path, alert: "Create your startup profile before submitting updates"
    end

    def startup_update_params
      params.require(:startup_update).permit(:report_month, :report_year, :mrr, :new_paying_customers, :churned_customers, :cash_at_hand, :burn_rate, :product_progress, :funding_stage, :funds_raised, :investors_engaged)
    end
  end
end
