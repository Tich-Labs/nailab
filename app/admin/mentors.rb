# app/admin/mentors.rb
ActiveAdmin.register User, as: "Mentor" do
  menu parent: "Users", priority: 4, label: "Mentors"

  actions :index, :show, :edit, :update, :destroy

  controller do
    def scoped_collection
      super.where(role: "mentor").includes(:user_profile)
    end
  end

  index download_links: false, class: "admin-table w-full text-sm text-gray-800 bg-white rounded-xl overflow-hidden shadow" do
    selectable_column
    id_column
    column :email do |u|
      link_to u.email, admin_mentor_path(u), class: "text-accent hover:underline"
    end
    column "Name", sortable: false do |u|
      u.user_profile&.full_name || "—"
    end
    column "Title", sortable: false do |u|
      u.user_profile&.title || "—"
    end
    column "Organization", sortable: false do |u|
      u.user_profile&.organization || "—"
    end
    column "Rate/Hour", sortable: false do |u|
      if u.user_profile&.pro_bono
        span "Pro Bono", class: "text-green-600 font-medium"
      elsif u.user_profile&.rate_per_hour.to_i > 0
        "$#{u.user_profile.rate_per_hour}"
      else
        "—"
      end
    end
    column "Created At" do |u|
      u.created_at&.strftime("%b %d, %Y at %I:%M %p")
    end
    actions defaults: false do |u|
      content_tag :div, class: "flex items-center gap-2" do
        safe_join([
          link_to("View", admin_mentor_path(u), class: "btn-primary text-xs px-3 py-1 rounded-md bg-primary hover:bg-primary-dark text-white"),
          link_to("Delete", admin_mentor_path(u), method: :delete, data: { confirm: "Are you sure?" }, class: "btn-secondary text-xs px-3 py-1 rounded-md bg-red-500 text-white hover:bg-red-700")
        ])
      end
    end
  end

  # Show: Stacked card panels (no tabs — fully supported)
  show title: ->(u) { "#{u.user_profile&.full_name || u.email} – Mentor Profile" } do
    div class: "space-y-10" do
      # Personal Profile Card
      div class: "bg-white rounded-2xl shadow-lg overflow-hidden" do
        div class: "bg-accent/10 px-8 py-5 border-b border-accent/20" do
          h3 class: "text-2xl font-bold text-accent" do
            "Personal Profile"
          end
        end
        div class: "px-8 py-6" do
          dl class: "grid grid-cols-1 md:grid-cols-2 gap-6" do
            dt class: "font-semibold text-gray-700" do "Full Name" end
            dd class: "text-gray-900" do resource.user_profile&.full_name || "—" end

            dt class: "font-semibold text-gray-700" do "Email" end
            dd class: "text-gray-900" do mail_to resource.email end

            dt class: "font-semibold text-gray-700" do "Bio" end
            dd class: "text-gray-900" do resource.user_profile&.bio&.html_safe || "—" end

            dt class: "font-semibold text-gray-700" do "Title" end
            dd class: "text-gray-900" do resource.user_profile&.title || "—" end

            dt class: "font-semibold text-gray-700" do "Organization" end
            dd class: "text-gray-900" do resource.user_profile&.organization || "—" end

            dt class: "font-semibold text-gray-700" do "LinkedIn" end
            dd class: "text-gray-900" do
              if resource.user_profile&.linkedin_url
                link_to resource.user_profile.linkedin_url, resource.user_profile.linkedin_url, target: "_blank", class: "text-accent hover:underline"
              else
                "—"
              end
            end

            dt class: "font-semibold text-gray-700" do "Years of Experience" end
            dd class: "text-gray-900" do resource.user_profile&.years_experience || "—" end

            dt class: "font-semibold text-gray-700" do "Advisory Experience" end
            dd class: "text-gray-900" do resource.user_profile&.advisory_experience || "—" end
          end
        end
      end

      # Mentor Expertise Card
      div class: "bg-white rounded-2xl shadow-lg overflow-hidden" do
        div class: "bg-accent/10 px-8 py-5 border-b border-accent/20" do
          h3 class: "text-2xl font-bold text-accent" do
            "Mentor Expertise & Availability"
          end
        end
        div class: "px-8 py-6" do
          dl class: "grid grid-cols-1 md:grid-cols-2 gap-6" do
            dt class: "font-semibold text-gray-700" do "Rate per Hour" end
            dd class: "text-gray-900" do
              if resource.user_profile&.pro_bono
                span "Pro Bono", class: "text-green-600 font-medium"
              elsif resource.user_profile&.rate_per_hour.to_i > 0
                "$#{resource.user_profile.rate_per_hour}"
              else
                "—"
              end
            end

            dt class: "font-semibold text-gray-700" do "Availability (Hours/Month)" end
            dd class: "text-gray-900" do resource.user_profile&.availability_hours_month || "—" end

            dt class: "font-semibold text-gray-700" do "Preferred Mentorship Mode" end
            dd class: "text-gray-900" do resource.user_profile&.preferred_mentorship_mode || "—" end

            dt class: "font-semibold text-gray-700" do "Pro Bono" end
            dd class: "text-gray-900" do
              resource.user_profile&.pro_bono ? span("✓ Yes", class: "text-green-600") : span("✗ No", class: "text-gray-500")
            end

            dt class: "font-semibold text-gray-700" do "Sectors" end
            dd class: "text-gray-900" do resource.user_profile&.sectors&.join(", ") || "—" end

            dt class: "font-semibold text-gray-700" do "Expertise" end
            dd class: "text-gray-900" do resource.user_profile&.expertise&.join(", ") || "—" end

            dt class: "font-semibold text-gray-700" do "Stage Preference" end
            dd class: "text-gray-900" do resource.user_profile&.stage_preference&.join(", ") || "—" end
          end
        end
      end

      # Mentorship Requests Card
      div class: "bg-white rounded-2xl shadow-lg overflow-hidden" do
        div class: "bg-accent/10 px-8 py-5 border-b border-accent/20" do
          h3 class: "text-2xl font-bold text-accent" do
            "Mentorship Requests"
          end
        end
        div class: "px-8 py-6" do
          requests = MentorshipRequest.where(mentor_id: resource.id).order(created_at: :desc)
          if requests.any?
            table_for requests, class: "table-auto w-full text-sm" do
              column "ID" do |r|
                link_to r.id, admin_mentorship_request_path(r), class: "text-accent hover:underline font-semibold"
              end
              column "Founder" do |r|
                link_to(r.founder.user_profile&.full_name || r.founder.email, admin_user_path(r.founder), class: "text-accent hover:underline")
              end
              column "Status" do |r|
                status_tag r.status,
                           class: case r.status
                                  when "pending"   then "bg-yellow-100 text-yellow-800"
                                  when "accepted"  then "bg-green-100 text-green-800"
                                  when "declined"  then "bg-red-100 text-red-800"
                                  end
              end
              column "Created" do |r|
                r.created_at.strftime("%b %d, %Y")
              end
            end
          else
            div class: "text-center py-12 text-gray-500 italic text-lg" do
              "No mentorship requests received yet."
            end
          end
        end
      end
    end
  end
end