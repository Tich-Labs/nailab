module AdminDashboardHelper
  def admin_sidebar_groups
    [
      {
        title: "🛎️ Support",
        sections: [
          { label: "Support queue", path: rails_admin.index_path(model_name: "support_ticket"), icon: "🧾", badge: @admin_support_ticket_alerts }
        ]
      },
      {
        title: "👥 Mentorship",
        sections: [
          { label: "Mentors", path: rails_admin.index_path(model_name: "user"), icon: "🧑‍🏫" },
          { label: "Mentees", path: rails_admin.index_path(model_name: "user_profile"), icon: "🧑‍🎓" },
          { label: "Requests", path: rails_admin.index_path(model_name: "mentorship_request"), icon: "🧾", badge: @admin_pending_requests },
          { label: "Sessions", path: rails_admin.index_path(model_name: "session"), icon: "🗓️" },
          { label: "Ratings", path: rails_admin.index_path(model_name: "rating"), icon: "⭐" }
        ]
      },
      {
        title: "💼 Startups",
        sections: [
          { label: "Startups", path: rails_admin.index_path(model_name: "startup_profile"), icon: "🚀" },
          { label: "Milestones", path: rails_admin.index_path(model_name: "milestone"), icon: "📌" },
          { label: "Submissions", path: rails_admin.index_path(model_name: "opportunity_submission"), icon: "📤" },
          { label: "Opportunities", path: rails_admin.index_path(model_name: "opportunity"), icon: "🎯" }
        ]
      },
      {
        title: "🔐 Users & Auth",
        sections: [
          { label: "Users", path: rails_admin.index_path(model_name: "user"), icon: "👤" },
          { label: "Profiles", path: rails_admin.index_path(model_name: "user_profile"), icon: "🧾" },
          { label: "Identities", path: rails_admin.index_path(model_name: "identity"), icon: "🆔" }
        ]
      },
      {
        title: "💬 Messaging & Comms",
        sections: [
          { label: "Messages", path: rails_admin.index_path(model_name: "message"), icon: "✉️" },
          { label: "Conversations", path: rails_admin.index_path(model_name: "conversation"), icon: "💬" },
          { label: "Peer Messages", path: rails_admin.index_path(model_name: "peer_message"), icon: "🤝" }
        ]
      },
      {
        title: "📈 Metrics & Analytics",
        sections: [
          { label: "Monthly Metrics", path: rails_admin.index_path(model_name: "monthly_metric"), icon: "📊" },
          { label: "Engagement Stats", path: rails_admin.index_path(model_name: "monthly_metric"), icon: "📈" }
        ]
      },
      {
        title: "🎯 Marketing",
        sections: [
          { label: "Hero Slides", path: rails_admin.index_path(model_name: "hero_slide"), icon: "🪄" },
          { label: "Testimonials", path: rails_admin.index_path(model_name: "testimonial"), icon: "🗣️" },
          { label: "Partners", path: rails_admin.index_path(model_name: "partner"), icon: "🤝" },
          { label: "Pages", path: rails_admin.index_path(model_name: "static_page"), icon: "📄" }
        ]
      },
      {
        title: "⚙️ System",
        sections: [
          { label: "JWTs", path: rails_admin.index_path(model_name: "jwt_denylist"), icon: "🔐" },
          { label: "Notifications", path: rails_admin.index_path(model_name: "notification"), icon: "🔔" },
          { label: "Admin Tools", path: rails_admin.index_path(model_name: "notification"), icon: "🛠️" }
        ]
      }
    ]
  end

  def admin_status_tag(status)
    color = case status.to_s
    when /pending/ then "bg-amber-100 text-amber-700"
    when /accepted|approved/ then "bg-emerald-100 text-emerald-700"
    when /declined/ then "bg-rose-100 text-rose-700"
    else "bg-slate-100 text-slate-700"
    end
    content_tag(:span, status.to_s.humanize, class: "rounded-full px-2 py-0.5 text-xs font-semibold #{color}")
  end

  def admin_breadcrumbs
    crumbs = [ { label: "Admin", path: rails_admin.dashboard_path } ]
    crumbs << { label: action_name.titleize, path: request.path } unless action_name == "dashboard"
    crumbs
  end

  def rails_admin_filter_params(field, value, operator: "is")
    return if value.blank?

    {
      field.to_s => {
        "1" => {
          "o" => operator,
          "v" => value.to_s
        }
      }
    }
  end

  def rails_admin_filtered_index_path(model_name:, field:, value:, operator: "is", **extra)
    filters = rails_admin_filter_params(field, value, operator: operator)
    path_options = { model_name: model_name }
    path_options.merge!(extra) if extra.any?
    path_options[:f] = filters if filters.present?
    rails_admin.index_path(path_options)
  end
end
