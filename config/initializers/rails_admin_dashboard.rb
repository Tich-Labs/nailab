require 'rails_admin'

Rails.application.config.to_prepare do
  RailsAdmin::MainController.class_eval do
    unless _process_action_callbacks.any? { |callback| callback.filter == :set_admin_layout_data }
      before_action :set_admin_layout_data
    end

    helper AdminDashboardHelper unless _helpers.included_modules.include?(AdminDashboardHelper)

    private

    def set_admin_layout_data
      @admin_pending_requests = MentorshipRequest.where(status: 'pending').count
      @admin_kpi_counts = {
        users: User.count,
        requests: MentorshipRequest.count,
        startups: StartupProfile.count
      }
      @admin_support_ticket_alerts = SupportTicket.where(status: 'open').count
      @admin_support_by_category = SupportTicket.group(:category).order('count_id desc').count(:id)
      @admin_support_by_status = SupportTicket.group(:status).count
      @admin_recent_support_tickets = SupportTicket.includes(:user).order(created_at: :desc).limit(4)

      return unless action_name == 'dashboard'

      @admin_recent_sessions = Session.order(created_at: :desc).limit(4)
      @admin_recent_requests = MentorshipRequest.order(created_at: :desc).limit(4)
      @admin_activity_feed = build_admin_activity_feed
      @admin_marketing_updates = fetch_marketing_updates
      @admin_monthly_signups = build_monthly_series(User, :created_at)
      @admin_monthly_sessions = build_monthly_series(Session, :created_at)
    end

    def build_admin_activity_feed
      entries = []
      @admin_recent_sessions.each do |session|
        entries << {
          type: :session,
          title: session.topic.presence || 'Mentorship Session',
          actor: display_user_name(session.user),
          time: session.created_at,
          link: rails_admin.show_path(model_name: 'session', id: session.id),
          status: 'completed'
        }
      end
      @admin_recent_requests.each do |request|
        entries << {
          type: :request,
          title: request.status.humanize,
          actor: display_user_name(request.founder),
          time: request.created_at,
          link: rails_admin.show_path(model_name: 'mentorship_request', id: request.id),
          status: request.status
        }
      end
      entries.sort_by { |entry| entry[:time] }.reverse.first(6)
    end

    def fetch_marketing_updates
      updates = []
      HeroSlide.order(updated_at: :desc).limit(3).each do |slide|
        updates << { title: slide.title.presence || 'Hero slide update', updated_at: slide.updated_at, path: rails_admin.show_path(model_name: 'hero_slide', id: slide.id), context: 'Hero slide' }
      end
      StaticPage.where(slug: %w[home about pricing contact]).order(updated_at: :desc).limit(3).each do |page|
        updates << { title: page.title, updated_at: page.updated_at, path: rails_admin.show_path(model_name: 'static_page', id: page.id), context: "Page: #{page.slug}" }
      end
      updates.sort_by { |update| update[:updated_at] }.reverse.first(5)
    end

    def build_monthly_series(model, column, months: 5)
      (0..months).map do |offset|
        period = Time.current.advance(months: -offset)
        range = period.beginning_of_month..period.end_of_month
        {
          label: period.strftime('%b'),
          value: model.where(column => range).count
        }
      end.reverse
    end

    def display_user_name(user)
      user&.user_profile&.full_name.presence || user&.email || 'User'
    end
  end
end
