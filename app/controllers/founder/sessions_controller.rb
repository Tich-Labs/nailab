class Founder::SessionsController < Founder::BaseController
  before_action :set_session, only: %i[show]

  def index
    @sessions = current_user.sessions
  end

  def show
  end

  def new
    @session = Session.new
  end

  def create
    @session = current_user.sessions.build(session_params)
    if @session.save
      redirect_to founder_sessions_path, notice: "Session booked."
    else
      render :new
    end
  end

  private

  def set_session
    @session = current_user.sessions.find(params[:id])
  end

  def session_params
    params.require(:session).permit(:mentor_id, :date, :time, :topic)
  end
end
