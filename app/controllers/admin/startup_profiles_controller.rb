module Admin
  class StartupProfilesController < ApplicationController
    layout "rails_admin/application"

    # Temporarily no auth for convenience

    def index
      @startups = StartupProfile.all.order(updated_at: :desc)

      if params[:q].present?
        q = params[:q].strip
        @startups = @startups.where("startup_name ILIKE :q OR description ILIKE :q", q: "%#{q}%")
      end
      @startups = @startups.where(sector: params[:sector]) if params[:sector].present?
      @startups = @startups.where(stage: params[:stage]) if params[:stage].present?
      @startups = @startups.where(funding_stage: params[:funding]) if params[:funding].present?
      @startups = @startups.where(location: params[:location]) if params[:location].present?

      if params[:visibility].present?
        case params[:visibility]
        when "approved"
          @startups = @startups.where(active: true) if StartupProfile.column_names.include?("active")
        when "archived"
          @startups = @startups.where(archived: true) if StartupProfile.column_names.include?("archived")
        when "pending"
          if StartupProfile.column_names.include?("active")
            @startups = @startups.where(active: [ false, nil ])
          end
        end
      end

      @startups = @startups.limit(200)

      @sector_options = defined?(SECTOR_OPTIONS) ? SECTOR_OPTIONS : StartupProfile.distinct.pluck(:sector).compact
      @stage_options = defined?(STAGE_OPTIONS) ? STAGE_OPTIONS : StartupProfile.distinct.pluck(:stage).compact
      @funding_options = defined?(FUNDING_OPTIONS) ? FUNDING_OPTIONS : StartupProfile.distinct.pluck(:funding_stage).compact
    end

    def show
      @startup = StartupProfile.find_by(slug: params[:id]) || StartupProfile.find(params[:id])
      render template: "admin/startups/show", layout: "rails_admin/application"
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_startup_profile_path, alert: "Startup not found."
    end

      def update
        startup = StartupProfile.find_by(slug: params[:id]) || StartupProfile.find(params[:id])

        # Update simple startup flags
        if params.key?(:public_profile)
          if startup.respond_to?(:profile_visibility=)
            startup.update(profile_visibility: params[:public_profile].to_s.in?([ "1", "true" ]))
          end
        end

        if params.key?(:notes) && startup.respond_to?(:moderator_notes=)
          startup.update(moderator_notes: params[:notes])
        end

        # Handle status change and trigger existing approve/reject flows
        status = params[:status].to_s
        if status.present? && startup.user&.user_profile
          begin
            case status
            when "approved"
              startup.user.user_profile.approve!(actor: (current_user if respond_to?(:current_user)))
            when "rejected"
              reason = params[:notes].presence || "Rejected by admin"
              startup.user.user_profile.reject!(reason: reason, actor: (current_user if respond_to?(:current_user)))
            when "archived"
              if startup.respond_to?(:archived=)
                startup.update(archived: true)
              else
                startup.update(active: false) if startup.respond_to?(:active=)
              end
              # set profile status if available
              if startup.user.user_profile.respond_to?(:update)
                startup.user.user_profile.update(profile_approval_status: "archived") rescue nil
              end
            when "pending"
              # mark as pending
              if startup.user.user_profile.respond_to?(:update)
                startup.user.user_profile.update(profile_approval_status: "pending") rescue nil
              end
            end
          rescue => e
            Rails.logger.error("Admin startup update status change failed: #{e.message}")
            # continue; we'll still redirect with notice
          end
        end

        redirect_to admin_startup_profile_path(startup), notice: "Profile updated."
      rescue => e
        redirect_back fallback_location: admin_startup_profile_path, alert: "Update failed: #{e.message}"
      end
    def approve
      startup = StartupProfile.find_by(slug: params[:id]) || StartupProfile.find(params[:id])
      startup.update(active: true) if startup.respond_to?(:active)

      if startup.user&.user_profile
        begin
          startup.user.user_profile.approve!(actor: (current_user if respond_to?(:current_user)))
        rescue => e
          Rails.logger.error("Failed to create profile audit on approve: #{e.message}")
        end
      end

      redirect_back fallback_location: admin_startup_profile_path, notice: "Startup approved."
    rescue => e
      redirect_back fallback_location: admin_startup_profile_path, alert: "Approve failed: #{e.message}"
    end

    def reject
      startup = StartupProfile.find_by(slug: params[:id]) || StartupProfile.find(params[:id])
      startup.update(active: false) if startup.respond_to?(:active)
      reason = params[:reason].presence || "Rejected by admin"

      if startup.user&.user_profile
        begin
          startup.user.user_profile.reject!(reason: reason, actor: (current_user if respond_to?(:current_user)))
        rescue => e
          Rails.logger.error("Failed to create profile audit on reject: #{e.message}")
        end
      end

      redirect_back fallback_location: admin_startup_profile_path, notice: "Startup rejected."
    rescue => e
      redirect_back fallback_location: admin_startup_profile_path, alert: "Reject failed: #{e.message}"
    end

    def archive
      startup = StartupProfile.find_by(slug: params[:id]) || StartupProfile.find(params[:id])
      if startup.respond_to?(:archived=)
        startup.update(archived: true)
      else
        startup.update(active: false) if startup.respond_to?(:active)
      end

      redirect_back fallback_location: admin_startup_profile_path, notice: "Startup archived."
    rescue => e
      redirect_back fallback_location: admin_startup_profile_path, alert: "Archive failed: #{e.message}"
    end

    private
  end
end
