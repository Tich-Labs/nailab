class ProgressService
  def initialize(user)
    @user = user
  end

  def get_milestones
    @user.milestones
  end

  def get_monthly_metrics
    # Include metrics from both the user and their primary startup
    user_metrics = @user.monthly_metrics.order(period: :asc)
    startup_metrics = @user.startup&.monthly_metrics&.order(period: :asc) || []

    # Combine and deduplicate by period, preferring startup metrics
    combined = {}
    user_metrics.each { |m| combined[m.period] = m }
    startup_metrics.each { |m| combined[m.period] = m }

    combined.values.sort_by(&:period)
  end

  def get_available_years
    years = get_monthly_metrics.map { |m| m.period&.year }.compact.uniq.sort
    ([ "All" ] + years.map(&:to_s)).freeze
  end

  def filter_metrics_by_year(year)
    metrics = get_monthly_metrics
    return metrics if year == "All"

    selected_year_int = year.to_i
    start_date = Date.new(selected_year_int, 1, 1)
    end_date = start_date.end_of_year
    metrics.where(period: start_date..end_date)
  end

  def prepare_chart_data(metrics)
    return [] if metrics.empty?

    @metrics_for_charts = metrics
      .group_by { |m| m.period.beginning_of_month }
      .map do |month, group|
        {
          period: month.strftime("%b %Y"),
          period_date: month.to_date,
          mrr: group.map(&:mrr).compact.sum.round(2),
          customers: group.map(&:customers).compact.max || 0,
          runway: group.map(&:runway).compact.first || 0,
          new: group.map(&:new_paying_customers).compact.sum || 0,
          churn: group.map(&:churned_customers).compact.sum || 0
        }
      end
  end

  def format_chart_labels(metrics_data)
    labels = []
    prev_year = nil

    metrics_data.each do |m|
      d = m[:period_date]
      y = d.year
      short_month = d.strftime("%b")[0]
      label = if prev_year != y
        "#{short_month} '#{y.to_s[-2..-1]}"
      else
        short_month
      end
      labels << label
      prev_year = y
    end

    labels
  end

  def get_runway_colors(metrics_data)
    metrics_data.map do |m|
      v = m[:runway].to_f
      v > 12 ? "#10b981" : v > 6 ? "#fbbf24" : "#ef4444"
    end
  end

  def build_chart_datasets(labels, metrics_data)
    {
      mrr_data: labels.zip(metrics_data.map { |m| m[:mrr].to_f }),
      total_customers_data: labels.zip(metrics_data.map { |m| m[:customers].to_i }),
      new_customers_data: labels.zip(metrics_data.map { |m| m[:new].to_i }),
      churn_customers_data: labels.zip(metrics_data.map { |m| m[:churn].to_i }),
      runway_data: labels.zip(metrics_data.map { |m| m[:runway].to_f }),
      runway_colors: get_runway_colors(metrics_data)
    }
  end

  def get_startup_updates(startup)
    return [] unless startup
    startup.startup_updates.order(report_year: :desc, report_month: :desc)
  end
end
