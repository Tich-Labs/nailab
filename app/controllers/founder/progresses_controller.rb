class Founder::ProgressesController < Founder::BaseController
  def show
    @milestones = current_user.milestones
    @monthly_metrics = current_user.monthly_metrics
    # years available for filtering (include 'All')
    years = @monthly_metrics.map { |m| m.period.year }.uniq.sort
    @available_years = ([ "All" ] + years.map(&:to_s)).freeze

    # Determine selected year: prefer explicit param, otherwise default to 'All'
    @selected_year = params[:year].presence || "All"

    # If a numeric year is selected, restrict metrics to that year
    if @selected_year.present? && @selected_year != "All"
      selected_year_int = @selected_year.to_i
      start_date = Date.new(selected_year_int, 1, 1)
      end_date = start_date.end_of_year
      @monthly_metrics = @monthly_metrics.where(period: start_date..end_date)
    end
    @startup = current_user.startup
    @startup_updates = @startup&.startup_updates&.order(report_year: :desc, report_month: :desc) || []

    # Prepare grouped metrics for charts (group by month in memory)
    if @monthly_metrics.any?
      @metrics_for_charts = @monthly_metrics
        .order(:period)
        .group_by { |m| m.period.beginning_of_month }
        .map do |month, metrics|
          {
            period: month.strftime("%b %Y"),
            period_date: month.to_date,
            mrr: metrics.map(&:mrr).compact.sum.round(2),
            customers: metrics.map(&:customers).compact.max || 0,
            runway: metrics.map(&:runway).compact.first || 0,
            new: metrics.map(&:new_paying_customers).compact.sum || 0,
            churn: metrics.map(&:churned_customers).compact.sum || 0
          }
        end
    else
      @metrics_for_charts = []
    end

    # Build chart-ready datasets (use short single-letter month labels; show two-digit year on year changes)
    labels = []
    prev_year = nil
    @metrics_for_charts.each do |m|
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

    @mrr_data = labels.zip(@metrics_for_charts.map { |m| m[:mrr].to_f })
    @total_customers_data = labels.zip(@metrics_for_charts.map { |m| m[:customers].to_i })
    @new_customers_data = labels.zip(@metrics_for_charts.map { |m| m[:new].to_i })
    @churn_customers_data = labels.zip(@metrics_for_charts.map { |m| m[:churn].to_i })
    # alias expected by some view examples
    @churn_data = @churn_customers_data
    @runway_data = labels.zip(@metrics_for_charts.map { |m| m[:runway].to_f })
    @runway_colors = @metrics_for_charts.map do |m|
      v = m[:runway].to_f
      v > 12 ? "#10b981" : v > 6 ? "#fbbf24" : "#ef4444"
    end
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
      @monthly_metrics = @periods.map { |period| MonthlyMetric.new(period: period) }
      @presets = ScenarioPreset.all
      # Flag first-time onboarding when the startup has no stored monthly metrics
      @first_time = current_user.startup&.monthly_metrics&.none?
    else
      # Handle submission: build objects, validate, render inline errors if present, otherwise persist
      raw_metrics = params[:monthly_metrics].to_unsafe_h rescue {}
      # If a per-step save was requested, only process that index and persist it immediately.
      if params[:save_step].present?
        idx = params[:save_step].to_i
        attrs = raw_metrics[idx.to_s] || raw_metrics[idx]
        if attrs.blank?
          redirect_to onboarding_founder_progress_path(step: idx), alert: "Nothing to save for that step." and return
        end
        # Build period from inputs (reuse logic)
        period = nil
        if attrs["period"].present?
          begin
            period = Date.parse(attrs["period"])
          rescue ArgumentError
            period = nil
          end
        elsif attrs["period_month"].present? && attrs["period_year"].present?
          begin
            period = Date.new(attrs["period_year"].to_i, attrs["period_month"].to_i, 1)
          rescue ArgumentError
            period = nil
          end
        end
        startup = current_user.startup
        existing = startup&.monthly_metrics&.find_by(period: period)
        mm = existing || startup&.monthly_metrics&.new(period: period)
        if mm.nil?
          redirect_to onboarding_founder_progress_path(step: idx), alert: "Unable to build monthly metric for that period." and return
        end
        mm.startup ||= startup
        mm.user = current_user
        mm.mrr = attrs["mrr"].present? ? BigDecimal(attrs["mrr"].to_s) : mm.mrr
        mm.new_paying_customers = attrs["new_paying_customers"].present? ? attrs["new_paying_customers"].to_i : mm.new_paying_customers
        mm.churned_customers = attrs["churned_customers"].present? ? attrs["churned_customers"].to_i : mm.churned_customers
        mm.cash_at_hand = attrs["cash_at_hand"].present? ? BigDecimal(attrs["cash_at_hand"].to_s) : mm.cash_at_hand
        mm.burn_rate = attrs["burn_rate"].present? ? BigDecimal(attrs["burn_rate"].to_s) : mm.burn_rate
        mm.baseline = (idx == 0 && session[:progress_mode] != "projection")
        if mm.valid?
          mm.save!
          redirect_to onboarding_founder_progress_path(step: idx), notice: "Saved metrics for #{period&.strftime('%b %Y') || 'selected month'}." and return
        else
          flash.now[:alert] = "Please fix errors for this month: #{mm.errors.full_messages.join(', ')}"
          @periods = @periods || (0..3).map { |i| Date.today.beginning_of_month }
          @monthly_metrics = @periods.map { |p| MonthlyMetric.new(period: p) }
          @monthly_metrics[idx] = mm
          @presets = ScenarioPreset.all
          render :onboarding and return
        end
      end
      startup = current_user.startup
      unless startup
        redirect_to founder_path, alert: "No startup associated with your account. Please create a startup first." and return
      end

      # Build metric objects in order
      built = raw_metrics.sort_by { |k, _| k.to_i }.map do |_idx, attrs|
        # accept either a full `period` or separate `period_month`+`period_year`
        next unless attrs["period"].present? || (attrs["period_month"].present? && attrs["period_year"].present?)
        period = nil
        if attrs["period"].present?
          begin
            period = Date.parse(attrs["period"])
          rescue ArgumentError
            period = nil
          end
        elsif attrs["period_month"].present? && attrs["period_year"].present?
          begin
            period = Date.new(attrs["period_year"].to_i, attrs["period_month"].to_i, 1)
          rescue ArgumentError
            period = nil
          end
        end
        existing = startup.monthly_metrics.find_by(period: period)
        mm = existing || startup.monthly_metrics.new(period: period)
        mm.startup = startup unless mm.startup
        mm.user = current_user
        # Assign submitted values (allow blanks)
        new_mrr = attrs["mrr"].present? ? BigDecimal(attrs["mrr"].to_s) : nil
        new_new_customers = attrs["new_paying_customers"].present? ? attrs["new_paying_customers"].to_i : nil
        new_churned = attrs["churned_customers"].present? ? attrs["churned_customers"].to_i : nil
        new_cash = attrs["cash_at_hand"].present? ? BigDecimal(attrs["cash_at_hand"].to_s) : nil
        new_burn = attrs["burn_rate"].present? ? BigDecimal(attrs["burn_rate"].to_s) : nil
        # Track overrides of projections for audit
        if existing&.is_projection
          @pending_audits ||= []
          { field: "mrr", old: existing.mrr, new: new_mrr } .tap do |h|
            @pending_audits << { period: period, field: "mrr", old: existing.mrr, new: new_mrr } if new_mrr.present? && existing.mrr.to_f != new_mrr.to_f
          end
          @pending_audits << { period: period, field: "new_paying_customers", old: existing.new_paying_customers, new: new_new_customers } if new_new_customers.present? && existing.new_paying_customers.to_i != new_new_customers.to_i
          @pending_audits << { period: period, field: "churned_customers", old: existing.churned_customers, new: new_churned } if new_churned.present? && existing.churned_customers.to_i != new_churned.to_i
          @pending_audits << { period: period, field: "cash_at_hand", old: existing.cash_at_hand, new: new_cash } if new_cash.present? && existing.cash_at_hand.to_f != new_cash.to_f
          @pending_audits << { period: period, field: "burn_rate", old: existing.burn_rate, new: new_burn } if new_burn.present? && existing.burn_rate.to_f != new_burn.to_f
        end

        mm.mrr = new_mrr.present? ? new_mrr : mm.mrr
        mm.new_paying_customers = new_new_customers.present? ? new_new_customers : mm.new_paying_customers
        mm.churned_customers = new_churned.present? ? new_churned : mm.churned_customers
        mm.cash_at_hand = new_cash.present? ? new_cash : mm.cash_at_hand
        mm.burn_rate = new_burn.present? ? new_burn : mm.burn_rate
        mm
      end.compact

      # Validate all
      invalid = built.each_with_index.select do |mm, i|
        # First row is baseline only when not in projection mode
        mm.baseline = (i == 0 && session[:progress_mode] != "projection")
        !mm.valid?
      end.map(&:first)

      if invalid.any?
        # Render onboarding with inline errors
        @periods = built.map(&:period)
        @monthly_metrics = built
        flash.now[:alert] = "Please fix the errors below."
        render :onboarding and return
      end

      # Persist all in transaction
      ActiveRecord::Base.transaction do
        built.each do |mm|
          mm.save!
        end
        # create projection audits after saves
        if defined?(@pending_audits) && @pending_audits.present?
          @pending_audits.each do |a|
            ProjectionAudit.create!(startup: startup, user: current_user, period: a[:period], field: a[:field], old_value: a[:old].to_s, new_value: a[:new].to_s, reason: "override_projection")
          end
        end
      end

      # Optionally create projections if requested (projection_length and preset_id)
      if params[:projection].present?
        projection_length = params[:projection][:length].to_i
        preset_id = params[:projection][:preset_id]
        if projection_length > 0 && preset_id.present?
          preset = ScenarioPreset.find_by(id: preset_id)
          if preset
            last_period = built.map(&:period).max
            last_mm = startup.monthly_metrics.find_by(period: last_period)
            create_projections(startup, last_mm, projection_length, preset)
          end
        end
      end

      flash[:notice] = "Monthly metrics saved successfully."
      redirect_to founder_path and return
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

  def create_projections(startup, last_mm, length, preset)
    return unless last_mm
    prev = last_mm
    (1..length).each do |i|
      period = (prev.period + 1.month)
      proj = startup.monthly_metrics.find_or_initialize_by(period: period)
      proj.is_projection = true
      proj.projection_index = i
      # Simple chaining: apply growth % to MRR and customers, churn reduces customers
      growth = preset.growth_pct.to_f / 100.0
      churn = preset.churn_pct.to_f / 100.0
      burn_change = preset.burn_change_pct.to_f / 100.0
      prev_mrr = prev.mrr.to_f
      prev_customers = prev.customers.to_i
      prev_cash = prev.cash_at_hand.to_f
      prev_burn = prev.burn_rate.to_f

      proj.mrr = (prev_mrr * (1 + growth)).round(2)
      proj.customers = (prev_customers + (prev_customers * growth) - (prev_customers * churn)).to_i
      proj.new_paying_customers = [ (proj.customers - prev_customers), 0 ].max
      proj.churned_customers = (prev_customers * churn).to_i
      proj.burn_rate = (prev_burn * (1 + burn_change)).round(2)
      proj.cash_at_hand = (prev_cash + proj.mrr - proj.burn_rate).round(2)
      proj.user = current_user
      proj.save!
      prev = proj
    end
  end
end
