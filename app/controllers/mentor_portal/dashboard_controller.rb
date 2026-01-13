class Mentor::DashboardController < Mentor::BaseController
  def show
    render template: "mentor/dashboard/show"
  end
end
