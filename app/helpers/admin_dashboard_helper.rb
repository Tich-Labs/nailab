module AdminDashboardHelper
  def admin_sidebar_groups
    [
      {
        title: "🛎️ Support",
        sections: [
            { label: "Support queue", path: nil, icon: "🧾", badge: @admin_support_ticket_alerts } # RailsAdmin removed
        ]
      },
      {
        title: "👥 Mentorship",
        sections: [
            { label: "Mentors", path: nil, icon: "🧑‍🏫" },
            { label: "Mentees", path: nil, icon: "🧑‍🎓" },
            { label: "Requests", path: nil, icon: "🧾", badge: @admin_pending_requests },
            { label: "Sessions", path: nil, icon: "🗓️" },
            { label: "Ratings", path: nil, icon: "⭐" }
        ]
      },
      {
        title: "💼 Startups",
        sections: [
            { label: "Startups", path: nil, icon: "🚀" },
            { label: "Milestones", path: nil, icon: "📌" },
            { label: "Submissions", path: nil, icon: "📤" },
            { label: "Opportunities", path: nil, icon: "🎯" }
        ]
      },
      {
        title: "🔐 Users & Auth",
        sections: [
            { label: "Users", path: nil, icon: "👤" },
            { label: "Profiles", path: nil, icon: "🧾" },
            { label: "Identities", path: nil, icon: "🆔" }
        ]
      },
      {
        title: "💬 Messaging & Comms",
        sections: [
            { label: "Messages", path: nil, icon: "✉️" },
            { label: "Conversations", path: nil, icon: "💬" },
            { label: "Peer Messages", path: nil, icon: "🤝" }
        ]
      },
      {
        title: "📈 Metrics & Analytics",
        sections: [
            { label: "Monthly Metrics", path: nil, icon: "📊" },
            { label: "Engagement Stats", path: nil, icon: "📈" }
        ]
      },
      {
        title: "🎯 Marketing",
        sections: [
            { label: "Hero Slides", path: nil, icon: "🪄" },
            { label: "Testimonials", path: nil, icon: "🗣️" },
          { label: "Partners", path: nil, icon: "🤝" },
          { label: "Pages", path: nil, icon: "📄" }
        ]
      },
      {
        title: "⚙️ System",
        sections: [
          { label: "JWTs", path: nil, icon: "🔐" },
          { label: "Notifications", path: nil, icon: "🔔" },
          { label: "Admin Tools", path: nil, icon: "🛠️" }
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
    crumbs = [ { label: "Admin", path: nil } ] # rails_admin.dashboard_path removed
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
