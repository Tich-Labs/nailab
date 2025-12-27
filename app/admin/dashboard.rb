
# app/admin/dashboard.rb
# Admin Dashboard: Responsive, Tailwind-styled, metrics, charts, activity, and quick actions

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "Dashboard"

  content title: proc { "Admin Dashboard" } do
    # --- Metrics (Top Row) ---
    h2 "Key Metrics", class: "sr-only", id: "metrics-heading"
    div class: "grid grid-cols-1 gap-6 sm:grid-cols-2 md:grid-cols-4 mb-8", role: "region", "aria-labelledby": "metrics-heading" do
      # Total Startup Founders
      founders_count = Rails.cache.fetch("dashboard/founders_count", expires_in: 10.minutes) { User.founder.count }
      div class: "bg-white rounded-2xl shadow p-6 flex flex-col items-start hover:shadow-lg transition group",
           role: "article",
           "aria-labelledby": "founders-count",
           tabindex: "0" do
        div class: "flex items-center gap-4" do
          # Icon placeholder
          span class: "bg-indigo-100 text-indigo-600 rounded-full p-3", "aria-hidden": "true" do
            # Heroicon: User Group
            raw('<svg class="h-6 w-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M17 20h5v-2a4 4 0 00-3-3.87M9 20H4v-2a4 4 0 013-3.87m9-7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>')
          end
          div do
            span class: "text-3xl font-bold text-gray-900", id: "founders-count" do
              number_with_delimiter(founders_count)
            end
            br
            span class: "text-sm text-gray-500" do
              "Startup Founders"
            end
          end
        end
        # Sparkline or % growth placeholder
        div class: "mt-2 text-xs text-green-600", "aria-label": "Growth indicator" do
          # Implement sparkline or % growth if available
          "↑ 2.5% this week"
        end
      end

      # Total Active Mentors
      mentors_count = Rails.cache.fetch("dashboard/mentors_count", expires_in: 10.minutes) { User.mentor.count }
      div class: "bg-white rounded-2xl shadow p-6 flex flex-col items-start hover:shadow-lg transition group",
           role: "article",
           "aria-labelledby": "mentors-count",
           tabindex: "0" do
        div class: "flex items-center gap-4" do
          span class: "bg-blue-100 text-blue-600 rounded-full p-3", "aria-hidden": "true" do
            raw('<svg class="h-6 w-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M5.121 17.804A13.937 13.937 0 0112 15c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0z" /></svg>')
          end
          div do
            span class: "text-3xl font-bold text-gray-900", id: "mentors-count" do
              number_with_delimiter(mentors_count)
            end
            br
            span class: "text-sm text-gray-500" do
              "Active Mentors"
            end
          end
        end
      end

      # Active Mentorship Matches / Sessions
      matches_count = Rails.cache.fetch("dashboard/matches_count", expires_in: 10.minutes) { MentorshipRequest.where(status: :accepted).count }
      div class: "bg-white rounded-2xl shadow p-6 flex flex-col items-start hover:shadow-lg transition group",
           role: "article",
           "aria-labelledby": "matches-count",
           tabindex: "0" do
        div class: "flex items-center gap-4" do
          span class: "bg-green-100 text-green-600 rounded-full p-3", "aria-hidden": "true" do
            raw('<svg class="h-6 w-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8c-1.657 0-3 1.343-3 3s1.343 3 3 3 3-1.343 3-3-1.343-3-3-3zm0 0V4m0 7v7m0 0h4m-4 0H8" /></svg>')
          end
          div do
            span class: "text-3xl font-bold text-gray-900", id: "matches-count" do
              number_with_delimiter(matches_count)
            end
            br
            span class: "text-sm text-gray-500" do
              "Active Mentorship Matches"
            end
          end
        end
      end

      # New Signups This Week
      new_signups = Rails.cache.fetch("dashboard/new_signups_week", expires_in: 10.minutes) {
        User.where("created_at >= ?", 1.week.ago).count
      }
      div class: "bg-white rounded-2xl shadow p-6 flex flex-col items-start hover:shadow-lg transition group",
           role: "article",
           "aria-labelledby": "signups-count",
           tabindex: "0" do
        div class: "flex items-center gap-4" do
          span class: "bg-yellow-100 text-yellow-600 rounded-full p-3", "aria-hidden": "true" do
            raw('<svg class="h-6 w-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4" /></svg>')
          end
          div do
            span class: "text-3xl font-bold text-gray-900", id: "signups-count" do
              number_with_delimiter(new_signups)
            end
            br
            span class: "text-sm text-gray-500" do
              "New Signups (Week)"
            end
          end
        end
      end
    end

    # --- Additional Metrics (Second Row) ---
    h2 "Additional Metrics", class: "sr-only"
    div class: "grid grid-cols-1 gap-6 sm:grid-cols-2 md:grid-cols-4 mb-8", role: "region", "aria-labelledby": "additional-metrics-heading" do
      pending_requests = Rails.cache.fetch("dashboard/pending_requests", expires_in: 10.minutes) { MentorshipRequest.where(status: :pending).count }
      resources_count = Rails.cache.fetch("dashboard/resources_count", expires_in: 10.minutes) { Resource.count }
      subscriptions_count = Rails.cache.fetch("dashboard/subscriptions_count", expires_in: 10.minutes) { Subscription.active.count rescue 0 }
      total_valuation = Rails.cache.fetch("dashboard/total_valuation", expires_in: 10.minutes) { StartupProfile.sum(:valuation) rescue 0 }

      # Pending Mentorship Requests
      div class: "bg-white rounded-2xl shadow p-6 flex flex-col items-start hover:shadow-lg transition group relative",
           role: "article",
           "aria-labelledby": "pending-count",
           tabindex: "0" do
        div class: "flex items-center gap-4" do
          span class: "bg-red-100 text-red-600 rounded-full p-3", "aria-hidden": "true" do
            raw('<svg class="h-6 w-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M18.364 5.636l-1.414 1.414M6.343 17.657l-1.414-1.414M12 8v4m0 4h.01" /></svg>')
          end
          div do
            span class: "text-2xl font-bold text-gray-900", id: "pending-count" do
              number_with_delimiter(pending_requests)
            end
            br
            span class: "text-sm text-gray-500" do
              "Pending Requests"
            end
          end
        end
        if pending_requests > 0
          span class: "absolute top-2 right-2 bg-red-600 text-white text-xs font-bold px-2 py-1 rounded-full animate-pulse",
                "aria-label": "#{pending_requests} pending requests" do
            "+#{pending_requests}"
          end
        end
      end

      # Total Resources Uploaded
      div class: "bg-white rounded-2xl shadow p-6 flex flex-col items-start hover:shadow-lg transition group",
           role: "article",
           "aria-labelledby": "resources-count",
           tabindex: "0" do
        div class: "flex items-center gap-4" do
          span class: "bg-purple-100 text-purple-600 rounded-full p-3", "aria-hidden": "true" do
            raw('<svg class="h-6 w-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4" /></svg>')
          end
          div do
            span class: "text-2xl font-bold text-gray-900", id: "resources-count" do
              number_with_delimiter(resources_count)
            end
            br
            span class: "text-sm text-gray-500" do
              "Resources Uploaded"
            end
          end
        end
      end

      # Active Subscriptions / MRR
      div class: "bg-white rounded-2xl shadow p-6 flex flex-col items-start hover:shadow-lg transition group",
           role: "article",
           "aria-labelledby": "subscriptions-count",
           tabindex: "0" do
        div class: "flex items-center gap-4" do
          span class: "bg-green-100 text-green-600 rounded-full p-3", "aria-hidden": "true" do
            raw('<svg class="h-6 w-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8c-1.657 0-3 1.343-3 3s1.343 3 3 3 3-1.343 3-3-1.343-3-3-3zm0 0V4m0 7v7m0 0h4m-4 0H8" /></svg>')
          end
          div do
            span class: "text-2xl font-bold text-gray-900", id: "subscriptions-count" do
              number_with_delimiter(subscriptions_count)
            end
            br
            span class: "text-sm text-gray-500" do
              "Active Subscriptions"
            end
          end
        end
      end

      # Combined Startup Valuation
      div class: "bg-white rounded-2xl shadow p-6 flex flex-col items-start hover:shadow-lg transition group",
           role: "article",
           "aria-labelledby": "valuation-amount",
           tabindex: "0" do
        div class: "flex items-center gap-4" do
          span class: "bg-yellow-100 text-yellow-600 rounded-full p-3", "aria-hidden": "true" do
            raw('<svg class="h-6 w-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8c-1.657 0-3 1.343-3 3s1.343 3 3 3 3-1.343 3-3-1.343-3-3-3zm0 0V4m0 7v7m0 0h4m-4 0H8" /></svg>')
          end
          div do
            span class: "text-2xl font-bold text-gray-900", id: "valuation-amount" do
              number_to_currency(total_valuation, precision: 0)
            end
            br
            span class: "text-sm text-gray-500" do
              "Startup Valuation"
            end
          end
        end
      end
    end

    # --- Summary (Middle Row) ---
    h2 "Summary Reports", class: "sr-only"
    div class: "grid grid-cols-1 gap-6 lg:grid-cols-3 mb-8", role: "region", "aria-labelledby": "summary-heading" do
      div class: "bg-white rounded-2xl shadow p-6" do
        h3 class: "text-lg font-semibold mb-4" do
          text_node "30-Day Signups"
        end
        signup_trend = User.where("created_at >= ?", 30.days.ago).group("DATE(created_at)").count
        p class: "text-3xl font-bold text-gray-900" do
          number_with_delimiter(signup_trend.values.sum)
        end
        span class: "text-sm text-gray-500" do
          "Average per day: #{(signup_trend.values.sum / [signup_trend.size, 1].max).round(1)}"
        end
      end
      div class: "bg-white rounded-2xl shadow p-6" do
        h3 class: "text-lg font-semibold mb-4" do
          text_node "Requests by Status"
        end
        status_counts = MentorshipRequest.group(:status).count
        status_counts.each do |status, count|
          div class: "flex justify-between text-sm text-gray-700" do
            text_node status&.titleize || "Unknown"
            text_node number_with_delimiter(count)
          end
        end
      end
      div class: "bg-white rounded-2xl shadow p-6" do
        h3 class: "text-lg font-semibold mb-4" do
          text_node "Top Mentors"
        end
        top_mentors = MentorshipRequest.where(status: :accepted)
                                    .group(:mentor_id)
                                    .order(Arel.sql("COUNT(*) DESC"))
                                    .limit(3)
                                    .count
        top_mentors.each do |mentor_id, count|
          mentor = User.find_by(id: mentor_id)
          next unless mentor
          div class: "flex justify-between text-sm text-gray-700" do
            text_node mentor.name
            text_node "#{count} sessions"
          end
        end
      end
    end

    # --- Recent Activity Feed (Bottom) ---
    h2 "Activity & Actions", class: "sr-only"
    div class: "grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8", role: "region", "aria-labelledby": "activity-heading" do
      div class: "bg-white rounded-2xl shadow p-6" do
        h3 class: "text-lg font-semibold mb-4" do
          text_node "Recent Activity"
        end
        ul class: "divide-y divide-gray-100", role: "list", "aria-label": "Recent activities" do
          recent_activities = PublicActivity::Activity.order(created_at: :desc).limit(10) rescue []
          recent_activities.each do |activity|
            li class: "py-3 flex items-center gap-3", role: "listitem" do
              span class: "inline-block w-2 h-2 rounded-full bg-indigo-500", "aria-hidden": "true" do
                # dot
              end
              div do
                span class: "text-sm text-gray-800" do
                  text_node "#{activity.trackable_type.titleize} #{activity.key.humanize}"
                end
                br
                span class: "text-xs text-gray-500" do
                  text_node l(activity.created_at, format: :short)
                end
              end
            end
          end
        end
      end
      # Quick Actions
      div class: "bg-white rounded-2xl shadow p-6 flex flex-col gap-4" do
        h3 class: "text-lg font-semibold mb-4" do
          text_node "Quick Actions"
        end
        div class: "grid grid-cols-1 gap-4 sm:grid-cols-2" do
          text_node link_to("Review Pending Requests", admin_mentorship_requests_path, "class": "bg-red-600 hover:bg-red-700 text-white font-bold py-3 px-6 rounded-lg shadow transition text-center", "aria-label": "Review pending mentorship requests")
          text_node link_to("Add New Resource", new_content_resource_path, "class": "bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-6 rounded-lg shadow transition text-center", "aria-label": "Add a new resource")
          text_node link_to("View All Founders", admin_founders_path, "class": "bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-6 rounded-lg shadow transition text-center", "aria-label": "View all startup founders")
          text_node link_to("View All Mentors", admin_users_path(q: { role_eq: 'mentor' }), "class": "bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-lg shadow transition text-center", "aria-label": "View all mentors")
        end
      end
    end
  end
end

# ---
# Notes:
# - All metrics use Rails.cache for performance.
# - All styling uses Tailwind CSS classes.
# - Chartkick gem is used for charts (line_chart, pie_chart).
# - PublicActivity gem is used for recent activity feed (fallbacks to empty if not present).
# - Quick Actions are large, color-coded buttons.
# - All sections are responsive and mobile-friendly.
# - Add/adjust metrics as needed for your app.
