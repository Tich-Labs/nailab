# app/admin/mentorship_requests.rb
#
# Manages mentorship matching requests between founders and mentors.
# Current schema: founder_id, mentor_id, status, message, proposed_time, feedback, etc.
#
# NOTE: This is for mentor-founder matching (existing users).
# For founder onboarding approval workflow (new signups), create a separate
# FounderApplication model with fields: full_name, email, startup_name, etc.
#
# IMPORTANT: Admins can only VIEW and APPROVE/DECLINE requests.
# Mentorship requests must be created by founders/mentors on the user-facing side.
#
ActiveAdmin.register MentorshipRequest do
  config.comments = true
  menu priority: 3, label: "Mentorship Requests"

  # Disable create, edit, and destroy actions (view-only with approval actions)
  actions :index, :show

  permit_params :status, :feedback, :decline_reason

  index do
    selectable_column
    id_column
    column "Founder", sortable: false do |r|
      r.founder.user_profile&.full_name || r.founder.email
    end
    column "Startup", sortable: false do |r|
      if r.founder.startup_profile
        div do
          div r.founder.startup_profile.startup_name, class: "font-medium"
          if r.founder.startup_profile.stage
            span r.founder.startup_profile.stage, class: "text-sm text-gray-500"
          end
        end
      else
        "—"
      end
    end
    column "Mentor", sortable: false do |r|
      r.mentor.user_profile&.full_name || r.mentor.email
    end
    column :status do |r|
      status_tag r.status.humanize
    end
    column "Proposed Time", sortable: false do |r|
      r.proposed_time || "—"
    end
    column :created_at
    actions
  end

  # Powerful filters for quick triage
  filter :status, as: :select, collection: -> { MentorshipRequest.statuses.keys.map { |s| [s.humanize, s] } }
  filter :founder_email, as: :string
  filter :mentor_email, as: :string
  filter :created_at
  filter :proposed_time

  # Detailed show page with organized panels
  show title: ->(r) { "Mentorship Request ##{r.id}" } do
    div style: "display: flex; gap: 2rem; flex-wrap: wrap;" do
      div style: "flex: 1 1 350px; min-width: 320px;" do
        # Founder & Startup Panel
        panel "Founder & Startup Details", class: "bg-white shadow rounded-lg" do
          attributes_table_for resource.founder do
            row "Founder Name" do |u|
              u.user_profile&.full_name || u.email
            end
            row :email do |u|
              mail_to u.email
            end
            row "Phone" do |u|
              u.user_profile&.phone || "—"
            end
            row "Location" do |u|
              [u.user_profile&.city, u.user_profile&.country].compact.join(", ").presence || "—"
            end
          end
          # Startup profile if exists
          if resource.founder.startup_profile
            startup = resource.founder.startup_profile
            attributes_table_for startup do
              row :startup_name
              row :description
              row :stage
              row :sector
              row :funding_stage
              row "Mentorship Areas Needed" do
                startup.mentorship_areas&.join(", ") || "—"
              end
            end
          else
            div "No startup profile created yet.", class: "text-gray-500 italic p-4"
          end
        end
      end
      div style: "flex: 1 1 350px; min-width: 320px;" do
        # Mentor Panel
        panel "Mentor Details", class: "bg-white shadow rounded-lg" do
          attributes_table_for resource.mentor do
            row "Mentor Name" do |u|
              u.user_profile&.full_name || u.email
            end
            row :email do |u|
              mail_to u.email
            end
            row "Title" do |u|
              u.user_profile&.title || "—"
            end
            row "Organization" do |u|
              u.user_profile&.organization || "—"
            end
            row "Expertise" do |u|
              u.user_profile&.expertise&.join(", ") || "—"
            end
            row "Sectors" do |u|
              u.user_profile&.sectors&.join(", ") || "—"
            end
            row "Rate" do |u|
              if u.user_profile&.pro_bono
                "Pro Bono"
              elsif u.user_profile&.rate_per_hour.to_i > 0
                "$#{u.user_profile.rate_per_hour}/hour"
              else
                "Not specified"
              end
            end
          end
        end
      end
    end
    
    # Request Details Panel
    panel "Request Details", class: "bg-white shadow rounded-lg mt-6" do
      attributes_table_for resource do
        row :status do
          status_class = case resource.status
          when "pending" then "bg-yellow-100 text-yellow-800"
          when "accepted" then "bg-green-100 text-green-800"
          when "declined" then "bg-red-100 text-red-800"
          else "bg-gray-100 text-gray-800"
          end
          span resource.status.humanize, class: "px-3 py-1 rounded-full text-sm font-medium #{status_class}"
        end
        row :areas_needed do |r|
          r.areas_needed&.any? ? r.areas_needed.join(", ") : "—"
        end
        row :preferred_mode
        row :message
        row :proposed_time
        row :feedback
        row :decline_reason if resource.declined_status?
        row :reschedule_reason if resource.reschedule_requested_status?
        row :responded_at
        row :created_at
        row :updated_at
      end
    end

      active_admin_comments_for(resource)
  end

  # Member actions for workflow
  member_action :accept, method: :put do
    resource.accept!
    redirect_to resource_path, notice: "✅ Mentorship request accepted!"
  end

  member_action :decline, method: :put do
    resource.decline!(reason: params[:decline_reason] || "Declined by admin")
    redirect_to resource_path, notice: "❌ Mentorship request declined."
  end

  # Action buttons in show page (using design system colors)
  action_item :accept, only: :show, if: proc { resource.pending_status? } do
    link_to "✓ Accept Request", 
            accept_admin_mentorship_request_path(resource), 
            method: :put,
            data: { confirm: "Accept this mentorship request?" },
            class: "bg-green-600 hover:bg-green-700 text-white font-semibold px-4 py-2 rounded-lg shadow transition"
  end

  action_item :decline, only: :show, if: proc { resource.pending_status? } do
    link_to "✗ Decline Request", 
            decline_admin_mentorship_request_path(resource), 
            method: :put,
            data: { confirm: "Decline this mentorship request?" },
            class: "bg-red-600 hover:bg-red-700 text-white font-semibold px-4 py-2 rounded-lg shadow transition"
  end

  # Batch actions for efficiency
  batch_action :accept, if: proc { true } do |ids|
    batch_action_collection.find(ids).each(&:accept!)
    redirect_to collection_path, notice: "✅ #{ids.count} request(s) accepted!"
  end

  batch_action :decline, if: proc { true } do |ids|
    batch_action_collection.find(ids).each { |r| r.decline!(reason: "Batch declined by admin") }
    redirect_to collection_path, notice: "❌ #{ids.count} request(s) declined."
  end

  # Scoped collection with eager loading
  controller do
    def scoped_collection
      super.includes(founder: [:user_profile, :startup_profile], mentor: :user_profile)
           .order(created_at: :desc)
    end
  end
end
