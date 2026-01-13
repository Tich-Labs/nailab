module Admin
  class MentorsController < ApplicationController
    include AdminLayoutData
    layout "rails_admin/application"

    before_action :set_admin_layout_data, only: %i[index]
    before_action :set_page_name, only: %i[index]

    def index
      base_scope = UserProfile.where(role: "mentor")
      @filters = {
        search: params[:q]&.strip,
        sector: params[:sector],
        location: params[:location]&.strip,
        pro_bono: params[:pro_bono]
      }
      @sector_options = base_scope.where.not(sectors: [ nil, [] ]).pluck(:sectors).flatten.compact.uniq.sort

      scoped = base_scope.order(:full_name)
      if @filters[:sector].present?
        scoped = scoped.where("sectors @> ?", [ @filters[:sector] ].to_json)
      end
      if @filters[:location].present?
        scoped = scoped.where("LOWER(location) LIKE ?", "%#{@filters[:location].downcase}%")
      end
      if @filters[:pro_bono].present?
        pro_bono_value = @filters[:pro_bono] == "true"
        scoped = scoped.where(pro_bono: pro_bono_value)
      end
      if @filters[:search].present?
        term = "%#{@filters[:search].downcase}%"
        scoped = scoped.where("LOWER(full_name) LIKE :term OR LOWER(organization) LIKE :term OR LOWER(bio) LIKE :term", term: term)
      end

      @filtered_mentors = scoped
      @mentor_counts = {
        total: base_scope.count,
        pending: base_scope.where(profile_approval_status: "pending").count
      }
    end

    private

    def set_page_name
      @page_name = "Mentors"
    end
  end
end
