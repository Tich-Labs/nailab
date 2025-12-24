# app/admin/users.rb
#
# Unified user management for founders, mentors, and admins.
# Design system: Primary #6A1B9A, Accent #00BCD4, clean spacing
#
# IMPORTANT: Admins can only VIEW and UPDATE users, not CREATE them.
# New users must register through the user-facing onboarding flows:
# - Founders: /founder_onboarding/new
# - Mentors: /mentor_onboarding/new
# - Regular users: /users/sign_up
#
ActiveAdmin.register User do
  menu priority: 2, label: "Users"

  # Disable create and destroy actions (can view and edit only)
  actions :index, :show, :edit, :update

  permit_params :email, :role, :confirmed_at,
                user_profile_attributes: [
                  :id, :full_name, :bio, :title, :organization, :linkedin_url,
                  :years_experience, :advisory_experience, :rate_per_hour,
                  :availability_hours_month, :preferred_mentorship_mode,
                  :pro_bono, :sectors, :expertise, :stage_preference
                ]

  # Only show founders and mentors (exclude admins and editors)
  controller do
    def scoped_collection
      super.where(role: ["founder", "mentor"])
    end
  end

  # Clean unified index with role badges
  index do
    selectable_column
    id_column
    column :email

    # Role badge with design system colors
    column :role do |u|
      role_class = case u.role
      when "founder"
        "bg-primary text-white"  # #6A1B9A
      when "mentor"
        "bg-accent text-white"   # #00BCD4
      when "admin"
        "bg-red-600 text-white"
      when "editor"
        "bg-orange-500 text-white"
      else
        "bg-gray-400 text-white"
      end

      span u.role.humanize, class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold uppercase #{role_class}"
    end

    column "Name", sortable: false do |u|
      u.user_profile&.full_name || "—"
    end

    column "Title/Startup", sortable: false do |u|
      if u.role == "mentor"
        u.user_profile&.title || "—"
      elsif u.role == "founder" && u.startup_profile
        u.startup_profile.startup_name
      else
        "—"
      end
    end

    column "Sectors", sortable: false do |u|
      sectors = if u.role == "mentor"
        u.user_profile&.sectors
      elsif u.role == "founder" && u.startup_profile
        [u.startup_profile.sector].compact
      end
      sectors&.join(", ") || "—"
    end

    column "Rate/Hour", sortable: false do |u|
      if u.role == "mentor"
        if u.user_profile&.pro_bono
          span "Pro Bono", class: "text-green-600 font-medium"
        elsif u.user_profile&.rate_per_hour.to_i > 0
          "$#{u.user_profile.rate_per_hour}"
        else
          "—"
        end
      else
        "—"
      end
    end

    column :created_at, sortable: :created_at do |u|
      u.created_at.strftime("%b %d, %Y")
    end

    actions
  end

  form do |f|
    f.semantic_errors

    f.inputs "User Account" do
      f.input :email
      f.input :role, as: :select, collection: User.roles.keys.map { |r| [r.humanize, r] }, include_blank: false
      f.input :confirmed_at, as: :datetime_picker if f.object.persisted?
    end

    f.inputs "Profile Information" do
      f.input :full_name, input_html: { value: f.object.user_profile&.full_name }
      f.input :bio, input_html: { value: f.object.user_profile&.bio }
      f.input :title, hint: "e.g., Founder & CEO, Investment Analyst", input_html: { value: f.object.user_profile&.title }
      f.input :organization, hint: "Or 'Independent Consultant'", input_html: { value: f.object.user_profile&.organization }
      f.input :linkedin_url, input_html: { value: f.object.user_profile&.linkedin_url }
    end

    if f.object.role == "mentor" || f.object.role.blank?
      f.inputs "Mentor Experience & Expertise", class: "mentor-fields border-l-4 border-accent pl-4 mt-6" do
        f.input :years_experience, as: :select,
                collection: ["Less than 3 years", "3–5 years", "6–10 years", "10+ years"],
                include_blank: false,
                input_html: { value: f.object.user_profile&.years_experience }
        f.input :advisory_experience, as: :radio,
                collection: [["Yes", true], ["No", false]],
                input_html: { value: f.object.user_profile&.advisory_experience }
        f.input :sectors, as: :check_boxes,
                collection: ["Agritech", "Healthtech", "Fintech", "Edutech", "Mobility & Logisticstech",
                           "E-commerce & Retailtech", "SaaS", "Creative & Mediatech", "Cleantech",
                           "AI & ML", "Robotics", "Mobiletech"],
                input_html: { value: f.object.user_profile&.sectors }
        f.input :expertise, as: :check_boxes,
                collection: ["Business model refinement", "Product-market fit", "Access to customers and markets",
                           "Go-to-market planning and launch", "Product development", "Pitching, fundraising, and investor readiness",
                           "Marketing and branding", "Team building and HR", "Budgeting and financial management",
                           "Market expansion (local or regional)", "Legal or regulatory guidance",
                           "Leadership and personal growth", "Strategic partnerships and collaborations",
                           "Sales and customer acquisition"],
                input_html: { value: f.object.user_profile&.expertise }
        f.input :stage_preference, as: :check_boxes,
                collection: ["Idea Stage", "Early Stage", "Growth Stage", "Scaling Stage"],
                input_html: { value: f.object.user_profile&.stage_preference }
      end

      f.inputs "Availability & Rates", class: "border-l-4 border-primary pl-4 mt-6" do
        f.input :rate_per_hour, hint: "Displayed on profile; leave blank or 0 for pro bono",
                input_html: { value: f.object.user_profile&.rate_per_hour }
        f.input :pro_bono, as: :boolean, input_html: { checked: f.object.user_profile&.pro_bono }
        f.input :availability_hours_month, as: :select,
                collection: ["Up to 2 hours per week", "3–5 hours per month", "6–10 hours per month",
                           "10+ hours per month", "Flexible"],
                input_html: { value: f.object.user_profile&.availability_hours_month }
        f.input :preferred_mentorship_mode, as: :radio,
                collection: [["Virtual Sessions", "virtual"], ["In-person Sessions", "in_person"], ["Both", "both"]],
                input_html: { value: f.object.user_profile&.preferred_mentorship_mode }
      end
    end

    f.actions
  end

  # Enhanced show page with conditional panels based on role
  show title: ->(u) { u.user_profile&.full_name || u.email } do
    columns do
      column do
        # Basic user info
        panel "User Account", class: "bg-white shadow rounded-lg" do
          attributes_table_for resource do
            row :email do
              mail_to resource.email
            end
            row :role do
              role_class = case resource.role
              when "founder" then "bg-primary text-white"
              when "mentor" then "bg-accent text-white"
              when "admin" then "bg-gray-700 text-white"
              else "bg-gray-400 text-white"
              end
              span resource.role.humanize, class: "px-3 py-1 rounded-full text-sm font-semibold #{role_class}"
            end
            row :confirmed_at
            row :created_at
            row :updated_at
          end
        end

        # Basic profile info (all users)
        if resource.user_profile
          panel "Profile Information", class: "bg-white shadow rounded-lg mt-6" do
            attributes_table_for resource.user_profile do
              row :full_name
              row :bio
              row :title
              row :organization
              row :phone if resource.role == "founder"
              row :country if resource.role == "founder"
              row :city if resource.role == "founder"
              row :linkedin_url do |p|
                link_to p.linkedin_url, p.linkedin_url, target: "_blank" if p.linkedin_url.present?
              end
            end
          end
        end
      end

      column do
        # CONDITIONAL PANEL: Mentor-specific details
        if resource.role == "mentor" && resource.user_profile
          panel "Mentor Expertise & Availability", class: "bg-accent bg-opacity-5 border-l-4 border-accent shadow rounded-lg" do
            attributes_table_for resource.user_profile do
              row "Years of Experience" do |p|
                p.years_experience || "—"
              end
              row "Advisory Experience" do |p|
                p.advisory_experience ? "Yes" : "No"
              end
              row "Sectors" do |p|
                if p.sectors&.any?
                  div do
                    p.sectors.map { |s| span s, class: "inline-block bg-accent bg-opacity-10 text-accent px-2 py-1 rounded text-sm mr-1 mb-1" }.join.html_safe
                  end
                else
                  "—"
                end
              end
              row "Expertise Areas" do |p|
                if p.expertise&.any?
                  div do
                    p.expertise.map { |e| span e, class: "inline-block bg-primary bg-opacity-10 text-primary px-2 py-1 rounded text-sm mr-1 mb-1" }.join.html_safe
                  end
                else
                  "—"
                end
              end
              row "Stage Preference" do |p|
                p.stage_preference&.join(", ") || "—"
              end
              row "Rate per Hour" do |p|
                if p.pro_bono
                  span "Pro Bono", class: "text-green-600 font-semibold"
                elsif p.rate_per_hour.to_i > 0
                  "$#{p.rate_per_hour}"
                else
                  "Not specified"
                end
              end
              row "Availability" do |p|
                p.availability_hours_month || "—"
              end
              row "Preferred Mode" do |p|
                p.preferred_mentorship_mode&.humanize || "—"
              end
            end
          end
        end

        # CONDITIONAL PANEL: Founder-specific details (linked startup)
        if resource.role == "founder"
          if resource.startup_profile
            startup = resource.startup_profile
            panel "Startup: #{startup.startup_name}", class: "bg-primary bg-opacity-5 border-l-4 border-primary shadow rounded-lg mt-6" do
              attributes_table_for startup do
                row :startup_name
                row :description
                row :target_market
                row :value_proposition
                row :stage do |s|
                  span s.stage, class: "px-2 py-1 bg-primary bg-opacity-20 text-primary rounded text-sm font-medium"
                end
                row :sector
                row :funding_stage
                row :funding_raised do |s|
                  s.funding_raised ? "$#{number_with_delimiter(s.funding_raised)}" : "—"
                end
                row :team_size
                row "Team Members" do |s|
                  if s.team_members&.any?
                    ul do
                      s.team_members.map { |m| li "#{m['name']} (#{m['role']})" }.join.html_safe
                    end
                  else
                    "—"
                  end
                end
                row :founded_year
                row "Mentorship Areas Needed" do |s|
                  if s.mentorship_areas&.any?
                    div do
                      s.mentorship_areas.map { |a| span a, class: "inline-block bg-red-100 text-red-800 px-2 py-1 rounded text-sm mr-1 mb-1" }.join.html_safe
                    end
                  else
                    "—"
                  end
                end
                row :challenge_details
                row :website_url do |s|
                  link_to s.website_url, s.website_url, target: "_blank" if s.website_url.present?
                end
                row :profile_visibility do |s|
                  s.profile_visibility ? span("✓ Public", class: "text-green-600") : span("✗ Private", class: "text-gray-500")
                end
              end
            end
          else
            panel "Startup Profile", class: "bg-gray-50 border border-gray-200 shadow rounded-lg mt-6" do
              div class: "text-center py-8 text-gray-500" do
                para "No startup profile created yet."
                para do
                  link_to "View Founder Profile", resource.user_profile ? "#profile" : "#", class: "text-primary hover:underline"
                end
              end
            end
          end
        end
      end
    end

    # Mentorship Requests Panel (for founders and mentors)
    panel "Mentorship Requests", class: "bg-white shadow rounded-lg mt-6" do
      requests = MentorshipRequest.where("founder_id = ? OR mentor_id = ?", resource.id, resource.id).order(created_at: :desc)
      if requests.any?
        table_for requests do
          column("ID") { |r| link_to r.id, admin_mentorship_request_path(r) }
          column("Role") { |r| r.founder_id == resource.id ? "Founder" : "Mentor" }
          column("Other Party") { |r| r.founder_id == resource.id ? (link_to(r.mentor.user_profile&.full_name || r.mentor.email, admin_user_path(r.mentor))) : (link_to(r.founder.user_profile&.full_name || r.founder.email, admin_user_path(r.founder))) }
          column("Status") { |r| status_tag r.status }
          column("Created At") { |r| r.created_at.strftime("%b %d, %Y") }
        end
      else
        div class: "text-gray-500 italic p-4" do
          "No mentorship requests found for this user."
        end
      end
    end

    active_admin_comments
  end

  # Scoped collection with eager loading for performance
  controller do
    def scoped_collection
      super.includes(:user_profile, :startup_profile).order(created_at: :desc)
    end
  end
end