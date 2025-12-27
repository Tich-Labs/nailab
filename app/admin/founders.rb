# app/admin/founders.rb
ActiveAdmin.register User, as: "Founder" do
  menu parent: "Users", priority: 3, label: "Founders"

  actions :index, :show, :edit, :update, :destroy

  controller do
    def scoped_collection
      super.where(role: "founder").includes(:user_profile, :startup_profile)
    end
  end

  index download_links: false, class: "admin-table w-full text-sm text-gray-800 bg-white rounded-xl overflow-hidden shadow" do
    selectable_column
    id_column
    column :email do |u|
      link_to u.email, admin_founder_path(u), class: "text-accent hover:underline"
    end
    column "Name", sortable: false do |u|
      u.user_profile&.full_name || "—"
    end
    column "Startup", sortable: false do |u|
      u.startup_profile&.startup_name || "—"
    end
    column "Stage", sortable: false do |u|
      if u.startup_profile&.stage
        span class: "inline-block bg-primary/10 text-primary px-3 py-1 rounded-full text-xs font-semibold border border-primary/20" do
          u.startup_profile.stage
        end
      else
        "—"
      end
    end
    column "Sector", sortable: false do |u|
      u.startup_profile&.sector || "—"
    end
    column "Created At" do |u|
      u.created_at&.strftime("%b %d, %Y at %I:%M %p")
    end
    actions defaults: false do |u|
      content_tag :div, class: "flex items-center gap-2" do
        safe_join([
          link_to("View", admin_founder_path(u), class: "btn-primary text-xs px-3 py-1 rounded-md bg-primary hover:bg-primary-dark text-white"),
          link_to("Delete", admin_founder_path(u), method: :delete, data: { confirm: "Are you sure?" }, class: "btn-secondary text-xs px-3 py-1 rounded-md bg-red-500 text-white hover:bg-red-700")
        ])
      end
    end
  end

  # Show: Stacked card panels (no tabs — fully supported)
  show title: ->(u) { "#{u.user_profile&.full_name || u.email} – Founder Profile" } do
    div class: "space-y-10" do
      # Personal Profile Card
      div class: "bg-white rounded-2xl shadow-lg overflow-hidden" do
        div class: "bg-primary/10 px-8 py-5 border-b border-primary/20" do
          h3 class: "text-2xl font-bold text-primary" do
            "Personal Profile"
          end
        end
        div class: "p-8 space-y-6" do
          div class: "aa-left-labels" do
            attributes_table do
            row :full_name do
              div class: "text-3xl font-bold text-primary" do
                resource.user_profile&.full_name
              end
            end
            row :email do
              mail_to resource.email, resource.email, class: "text-xl text-accent hover:underline font-medium"
            end
            row :phone
            row :country
            row :city
            row :bio do
              if resource.user_profile&.bio.present?
                div class: "prose prose-lg max-w-none mt-4 text-neutral-dark" do
                  simple_format resource.user_profile.bio
                end
              else
                em "No bio provided", class: "text-gray-500"
              end
            end
            row :title
            row :organization
            row "LinkedIn" do
              if resource.user_profile&.linkedin_url.present?
                link_to "View LinkedIn Profile", resource.user_profile.linkedin_url,
                        target: "_blank", class: "inline-flex items-center gap-2 bg-accent text-white px-5 py-3 rounded-lg hover:bg-accent/90 font-medium"
              end
            end
            end
          end
        end
      end

      # Startup Profile Card
      if resource.startup_profile
        div class: "bg-white rounded-2xl shadow-lg overflow-hidden" do
          div class: "bg-primary/10 px-8 py-5 border-b border-primary/20" do
            h3 class: "text-2xl font-bold text-primary" do
              "Startup Profile"
            end
          end
          div class: "p-8 space-y-6" do
            div class: "aa-left-labels" do
              attributes_table do
              row :startup_name do
                div class: "text-3xl font-bold text-primary" do
                  resource.startup_profile.startup_name
                end
              end
              row :description do
                div class: "prose prose-lg max-w-none mt-4 text-neutral-dark" do
                  simple_format resource.startup_profile.description
                end
              end
              row :target_market
              row :value_proposition
              row :stage do
                span class: "inline-block bg-primary/10 text-primary px-5 py-2 rounded-full font-semibold" do
                  resource.startup_profile.stage
                end
              end
              row :sector do
                span class: "inline-block bg-accent/10 text-accent px-5 py-2 rounded-full font-semibold" do
                  resource.startup_profile.sector
                end
              end
              row :funding_stage
              row :funding_raised do
                if resource.startup_profile.funding_raised.present?
                  div class: "text-2xl font-bold text-green-600" do
                    number_to_currency resource.startup_profile.funding_raised
                  end
                end
              end
              row :team_size
              row "Team Members" do
                if resource.startup_profile.team_members&.any?
                  div class: "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-6" do
                    resource.startup_profile.team_members.each do |m|
                      div class: "bg-neutral p-5 rounded-xl border border-gray-200" do
                        div class: "font-semibold text-primary" do
                          m['name']
                        end
                        div class: "text-sm text-neutral-dark mt-1" do
                          m['role']
                        end
                      end
                    end
                  end
                else
                  em "No team members listed", class: "text-gray-500"
                end
              end
              row :founded_year
              row "Mentorship Areas Needed" do
                div class: "flex flex-wrap gap-3 mt-4" do
                  resource.startup_profile.mentorship_areas&.each do |area|
                    span class: "inline-block bg-primary/10 text-primary px-5 py-2 rounded-full text-sm font-medium" do
                      area
                    end
                  end || em("Not specified", class: "text-gray-500")
                end
              end
              row :challenge_details do
                if resource.startup_profile.challenge_details.present?
                  div class: "prose max-w-none mt-4 text-neutral-dark" do
                    simple_format resource.startup_profile.challenge_details
                  end
                end
              end
              row "Website" do
                if resource.startup_profile.website_url.present?
                  link_to resource.startup_profile.website_url, resource.startup_profile.website_url,
                          target: "_blank", class: "text-accent hover:underline font-medium"
                end
              end
              row :profile_visibility do
                status_tag resource.startup_profile.profile_visibility ? "Public" : "Private",
                           class: resource.startup_profile.profile_visibility ? "bg-green-100 text-green-800" : "bg-gray-100 text-gray-800"
              end
              end
            end
          end
        end
      end

      # Mentorship Requests History Card
      div class: "bg-white rounded-2xl shadow-lg overflow-hidden" do
        div class: "bg-primary/10 px-8 py-5 border-b border-primary/20" do
          h3 class: "text-2xl font-bold text-primary" do
            "Mentorship Requests History"
          end
        end
        div class: "p-8" do
          requests = resource.mentorship_requests.order(created_at: :desc)
          if requests.any?
            table_for requests, class: "w-full table-auto border-collapse" do
              column "Request ID" do |r|
                link_to r.id, admin_mentorship_request_path(r), class: "text-accent font-bold hover:underline"
              end
              column "Mentor" do |r|
                if r.mentor
                  link_to r.mentor.user_profile&.full_name || r.mentor.email,
                          admin_user_path(r.mentor), class: "text-primary hover:underline font-medium"
                else
                  em "Pending match", class: "text-gray-500 italic"
                end
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
              "No mentorship requests submitted yet."
            end
          end
        end
      end
    end

  end
end