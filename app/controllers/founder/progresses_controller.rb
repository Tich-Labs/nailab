require "ostruct"

class Founder::ProgressesController < Founder::BaseController
  def show
    @service = ProgressService.new(current_user)

    @milestones = @service.get_milestones
    all_metrics = @service.get_monthly_metrics
    @available_years = @service.get_available_years

    # Determine selected year: prefer explicit param, otherwise default to 'All'
    @selected_year = params[:year].presence || "All"

    # Build a timeline of months to display:
    if @selected_year == "All"
      end_month = Date.today.beginning_of_month
      start_month = (end_month - 11.months).beginning_of_month
    else
      yr = @selected_year.to_i
      start_month = Date.new(yr, 1, 1)
      end_month = start_month.end_of_year.beginning_of_month
    end

    # Map existing metrics by period (as Date) for quick lookup — normalize keys to Date to avoid mismatch
    metrics_map = all_metrics.index_by { |m| m.period.to_date }

    # Build a list of 12 (or 12/yr) months and ensure placeholders exist for missing months
    months = []
    m = start_month
    while m <= end_month
      months << m
      m = (m + 1.month).beginning_of_month
    end

    @monthly_metrics = months.map do |period_month|
      if metrics_map[period_month]
        metrics_map[period_month]
      else
        o = OpenStruct.new(period: period_month, mrr: 0, customers: 0, runway: 0, new_paying_customers: 0, churned_customers: 0, burn_rate: 0)
        # ensure `is_projection?` predicate exists like ActiveRecord models
        def o.is_projection?; false; end
        o
      end
    end

    # Also expose the latest persisted actual metrics (from DB) for KPI cards so placeholders don't override real data
    db_actuals = all_metrics.select { |m| !m.is_projection? }
    @latest_actual_db = db_actuals.max_by(&:period)
    @prev_actual_db = db_actuals.sort_by(&:period).reverse[1]

    @startup = current_user.startup
    @startup_updates = @service.get_startup_updates(@startup)

    # Prepare grouped metrics for charts
    @metrics_for_charts = @service.prepare_chart_data(@monthly_metrics)

    # Build chart-ready datasets
    labels = @service.format_chart_labels(@metrics_for_charts)
    chart_data = @service.build_chart_datasets(labels, @metrics_for_charts)

    @mrr_data = chart_data[:mrr_data]
    @total_customers_data = chart_data[:total_customers_data]
    @new_customers_data = chart_data[:new_customers_data]
    @churn_customers_data = chart_data[:churn_customers_data]
    @churn_data = @churn_customers_data # alias expected by some view examples
    @runway_data = chart_data[:runway_data]
    @runway_colors = chart_data[:runway_colors]
  end


  def onboarding
    if request.get?
      # Determine mode (projection vs historical)
      # Use the latest existing metric as the reference month when available.
      # Prefer the startup's stored monthly metrics (these are the authoritative records),
      # fall back to any user-scoped metrics, then to today.
      startup_metrics_last = current_user.startup&.monthly_metrics&.order(period: :asc)&.last&.period&.beginning_of_month
      user_metrics_last = current_user.monthly_metrics&.order(period: :asc)&.last&.period&.beginning_of_month
      ref_month = startup_metrics_last || user_metrics_last || Date.today.beginning_of_month
      if session[:progress_mode] == "projection"
        # Projection Mode: start at reference month and project forward
        @periods = 0.upto(3).map { |i| (ref_month + i.months).beginning_of_month }
      else
        # Historical onboarding: show a 4-month window ending at the reference month
        # (earliest -> latest). The earliest can serve as an optional baseline.
        @periods = (0..3).map { |i| (ref_month - (3 - i).months).beginning_of_month }
      end
      # Exclude months that already have stored metrics for this startup - onboarding should only add new months
      if current_user.startup.present?
        existing_periods = current_user.startup.monthly_metrics.pluck(:period)
        @periods = @periods.reject { |p| existing_periods.include?(p) }
      end
      # Ensure at least one blank month is shown for onboarding (so the form isn't empty)
      if @periods.empty?
        @periods = [ (ref_month + 1.month).beginning_of_month ]
      end
      # Build a list of available months the user can pick from based on stored metrics.
      if current_user.startup&.monthly_metrics&.any?
        first_period = current_user.startup.monthly_metrics.order(period: :asc).first.period.beginning_of_month
        last_period = current_user.startup.monthly_metrics.order(period: :asc).last.period.beginning_of_month
        months = []
        p = first_period
        while p <= last_period
          months << p
          p = (p + 1.month).beginning_of_month
        end
        @available_periods = months
      else
        # Fallback: expose a recent 12-month window ending at the reference month
        @available_periods = (0..11).map { |i| (ref_month - i.months).beginning_of_month }.reverse
      end
      # Month and year selects for onboarding (months Jan..Dec, years 2020..2030)
      @month_options = (1..12).map { |m| [ Date::MONTHNAMES[m], m ] }
      @year_options = (2020..2030).to_a
      # Build fresh (unsaved) MonthlyMetric objects for the empty months the user can add
      @monthly_metrics = @periods.map { |period| MonthlyMetric.new(period: period) }
      @presets = ScenarioPreset.all
      # Flag first-time onboarding when the startup has no stored monthly metrics
      @first_time = current_user.startup&.monthly_metrics&.none?
    else
      startup = current_user.startup
      unless startup
        redirect_to founder_path, alert: "No startup associated with your account. Please create a startup first." and return
      end

      raw_metrics = params[:monthly_metrics].to_unsafe_h rescue {}

      # Handle per-step saves
      if params[:save_step].present?
        idx = params[:save_step].to_i
        attrs = raw_metrics[idx.to_s] || raw_metrics[idx]
        redirect_to onboarding_founder_progress_path(step: idx), alert: "Nothing to save for that step." and return if attrs.blank?

        period = parse_period(attrs)
        existing = startup.monthly_metrics.find_by(period: period)
        mm = existing || startup.monthly_metrics.new(period: period)

        unless mm
          redirect_to onboarding_founder_progress_path(step: idx), alert: "Unable to save metrics for that period." and return
        end

        mm.startup ||= startup
        mm.user = current_user
        mm.baseline = (idx == 0 && session[:progress_mode] != "projection")
        assign_metric_attributes(mm, attrs)

        if mm.valid?
          mm.save!
          redirect_to onboarding_founder_progress_path(step: idx), notice: "Saved metrics for #{period&.strftime('%b %Y') || 'selected month'}." and return
        else
          @periods = (0..3).map { |i| Date.today.beginning_of_month }
          @monthly_metrics = @periods.map { |p| MonthlyMetric.new(period: p) }
          @monthly_metrics[idx] = mm
          @presets = ScenarioPreset.all
          flash.now[:alert] = "Please fix errors: #{mm.errors.full_messages.join(', ')}"
          render :onboarding and return
        end
      end

      # Build and validate all metrics
      built = raw_metrics.sort_by { |k, _| k.to_i }.map do |_idx, attrs|
        next unless attrs["period"].present? || (attrs["period_month"].present? && attrs["period_year"].present?)

        period = parse_period(attrs)
        existing = startup.monthly_metrics.find_by(period: period)
        mm = existing || startup.monthly_metrics.new(period: period)
        mm.startup = startup unless mm.startup
        mm.user = current_user
        assign_metric_attributes(mm, attrs)
        mm
      end.compact

      # Validate and render with errors if needed
      built.each_with_index { |mm, i| mm.baseline = (i == 0 && session[:progress_mode] != "projection") }
      invalid = built.reject(&:valid?)

      if invalid.any?
        @periods = built.map(&:period)
        @monthly_metrics = built
        @presets = ScenarioPreset.all
        flash.now[:alert] = "Please fix the errors below."
        render :onboarding and return
      end

      # Persist all in transaction
      ActiveRecord::Base.transaction do
        built.each(&:save!)
      end

      # Create projections if requested
      if params[:projection].present?
        projection_length = params[:projection][:length].to_i
        preset_id = params[:projection][:preset_id]
        if projection_length > 0 && preset_id.present?
          preset = ScenarioPreset.find_by(id: preset_id)
          if preset
            last_mm = startup.monthly_metrics.find_by(period: built.map(&:period).max)
            create_projections(startup, last_mm, projection_length, preset) if last_mm
          end
        end
      end

      flash[:notice] = "Monthly metrics saved successfully."
      redirect_to founder_path
    end
  end

  def stage
    if request.get?
      render :stage
    else
      mode = params[:mode]
      session[:progress_mode] = mode
      redirect_to onboarding_founder_progress_path
    end
  end

  private

  def parse_period(attrs)
    if attrs["period"].present?
      begin
        Date.parse(attrs["period"])
      rescue ArgumentError
        nil
      end
    elsif attrs["period_month"].present? && attrs["period_year"].present?
      begin
        Date.new(attrs["period_year"].to_i, attrs["period_month"].to_i, 1)
      rescue ArgumentError
        nil
      end
    end
  end

  def assign_metric_attributes(mm, attrs)
    mm.mrr = BigDecimal(attrs["mrr"]) if attrs["mrr"].present?
    mm.new_paying_customers = attrs["new_paying_customers"].to_i if attrs["new_paying_customers"].present?
    mm.churned_customers = attrs["churned_customers"].to_i if attrs["churned_customers"].present?
    if ActiveRecord::Base.connection.column_exists?(:monthly_metrics, :cash_at_hand)
      mm.cash_at_hand = BigDecimal(attrs["cash_at_hand"]) if attrs["cash_at_hand"].present?
    end
    mm.burn_rate = BigDecimal(attrs["burn_rate"]) if attrs["burn_rate"].present?
    # If `customers` was provided explicitly use it, otherwise attempt to derive it from previous month's stored metric
    if attrs["customers"].present?
      mm.customers = attrs["customers"].to_i
    else
      if mm.customers.blank? && mm.startup.present? && mm.period.present?
        prev = mm.startup.monthly_metrics.where("period < ?", mm.period).order(period: :asc).last
        prev_count = prev&.customers.to_i
        mm.customers = [ prev_count + mm.new_paying_customers.to_i - mm.churned_customers.to_i, 0 ].max
      end
    end
  end

  def create_projections(startup, last_mm, length, preset)
    return unless last_mm

    prev = last_mm
    (1..length).each do |i|
      proj = startup.monthly_metrics.find_or_initialize_by(period: prev.period + 1.month)
      proj.is_projection = true
      proj.projection_index = i
      proj.user = current_user

      growth = preset.growth_pct.to_f / 100.0
      churn = preset.churn_pct.to_f / 100.0
      burn_change = preset.burn_change_pct.to_f / 100.0

      proj.mrr = (prev.mrr.to_f * (1 + growth)).round(2)
      proj.customers = (prev.customers.to_i * (1 + growth - churn)).to_i
      proj.new_paying_customers = [ (proj.customers - prev.customers.to_i), 0 ].max
      proj.churned_customers = (prev.customers.to_i * churn).to_i
      proj.burn_rate = (prev.burn_rate.to_f * (1 + burn_change)).round(2)
      if ActiveRecord::Base.connection.column_exists?(:monthly_metrics, :cash_at_hand)
        proj.cash_at_hand = (prev.cash_at_hand.to_f + proj.mrr - proj.burn_rate).round(2)
      end

      proj.save!
      prev = proj
    end
  end
end
