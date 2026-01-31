namespace :db do
  desc "Seed founder4 monthly metrics (idempotent). Usage: RAILS_ENV=production FOUNDER4_SLUG=slug bin/rails db:seed_founder4"
  task seed_founder4: :environment do
    slug = ENV.fetch("FOUNDER4_SLUG", "founder4-test-nailab-app")
    user = User.find_by(slug: slug)
    unless user
      puts "founder4 user not found (slug: #{slug}) - aborting"
      next
    end

    startup = Startup.find_or_create_by!(user_id: user.id) do |s|
      s.name = "Founder4 Startup"
      s.active = true if s.respond_to?(:active=)
    end

    created = 0
    6.downto(1) do |i|
      period = Date.today.prev_month(i - 1).beginning_of_month
      next if MonthlyMetric.exists?(startup_id: startup.id, period: period)

      mrr = (i * 1500).to_f
      new_customers = [ 1, i * 2 ].max
      churned = (new_customers * 0.08).round
      cash = 20_000 + (i * 2_500)
      burn = 6_000 + (i * 400)

      MonthlyMetric.create!(
        startup: startup,
        user: user,
        period: period,
        mrr: mrr,
        new_paying_customers: new_customers,
        churned_customers: churned,
        cash_at_hand: cash,
        burn_rate: burn,
        product_progress: "Metrics seeded for founder4",
        funding_stage: "Bootstrapped"
      )
      created += 1
    end

    puts "✅ Seeded #{created} MonthlyMetric(s) for user=#{user.email} (startup_id=#{startup.id})"
  end
end
