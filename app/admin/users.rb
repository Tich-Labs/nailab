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
  actions :index, :show, :edit, :update, :destroy

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
  index download_links: false, class: "admin-table w-full text-sm text-gray-800 bg-white rounded-xl overflow-hidden shadow" do
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

    column "Created At" do |u|
      u.created_at&.strftime("%b %d, %Y at %I:%M %p")
    end

    actions defaults: false do |u|
      content_tag :div, class: "flex items-center gap-2" do
        safe_join([
          link_to("View", admin_user_path(u), class: "btn-primary text-xs px-3 py-1 rounded-md bg-primary hover:bg-primary-dark text-white"),
          link_to("Delete", admin_user_path(u), method: :delete, data: { confirm: "Are you sure?" }, class: "btn-secondary text-xs px-3 py-1 rounded-md bg-red-500 text-white hover:bg-red-700")
        ])
      end
    end
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
    div class: "max-w-3xl mx-auto bg-white rounded-xl shadow p-8 space-y-6" do
      attributes_table_for resource do
        row :id
        row :email
        row :role
        row :confirmed_at
        row :created_at
        row :updated_at
      end
      div class: "flex gap-4 mt-8" do
        span do
          link_to "Edit", edit_admin_user_path(resource), class: "btn-primary text-xs px-4 py-2 rounded-md bg-primary hover:bg-primary-dark text-white"
        end
        span do
          link_to "Delete", admin_user_path(resource), method: :delete, data: { confirm: "Are you sure?" }, class: "btn-secondary text-xs px-4 py-2 rounded-md bg-red-500 text-white hover:bg-red-700"
        end
      end
    end
  end

  # Scoped collection with eager loading for performance
  controller do
    def scoped_collection
      super.includes(:user_profile, :startup_profile).order(created_at: :desc)
    end
  end
end