module Admin
  class MentorshipRequestsController < ApplicationController
    include AdminAuthorization
    include AdminLayoutData
    layout "rails_admin/application"
    before_action :set_admin_layout_data, only: [ :index ]
    before_action :set_page_name, only: [ :index ]

    def index
      authorize :admin, :dashboard?
    end

    private

    def set_page_name
      @page_name = "Mentorship Requests"
    end
  end
end
