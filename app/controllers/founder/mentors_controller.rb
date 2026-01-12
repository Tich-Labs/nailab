class Founder::MentorsController < Founder::BaseController
  def index
    @mentors = Mentor.all
  end

  def show
    # Support friendly slugs as well as numeric IDs
    @mentor = Mentor.find_by(slug: params[:id]) || Mentor.find(params[:id])
  end
end
