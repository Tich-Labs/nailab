# Seed monthly metrics for founder user id 4: baseline (Dec 2024) through Dec 2025
seed_user_id = ENV['SEED_USER_ID']
seed_email = ENV['SEED_EMAIL']
user = if seed_user_id.present?
  User.find_by(id: seed_user_id)
elsif seed_email.present?
  User.find_by(email: seed_email)
else
  # fallback to an audit founder if present
  User.find_by(email: 'audit_founder1@example.com') || User.first
end
raise "User not found (pass SEED_USER_ID or SEED_EMAIL)" unless user
startup = user.startup || Startup.create!(user: user, name: "#{user.email || 'Founder'} Startup")

start_period = Date.new(2024, 12, 1) # baseline
end_period = Date.new(2025, 12, 1)

# initial assumptions
mrr = 500.0
customers = 50
cash = 20000.0
burn = 8000.0

growth_pct = 0.08 # 8% monthly
churn_pct = 0.02

period = start_period
created = []
while period <= end_period
  # calculate values for this period
  if period == start_period
    # baseline: smaller values
    mrr = 300.0
    customers = 30
    cash = 15000.0
    burn = 7000.0
  else
    # project growth from previous
    mrr = (mrr * (1 + growth_pct)).round(2)
    new_customers = [ (customers * growth_pct).round, 1 ].max
    churned = (customers * churn_pct).round
    customers = customers + new_customers - churned
    cash = (cash + mrr - burn).round(2)
    # small monthly increase in burn
    burn = (burn * 1.01).round(2)
  end

  mm = MonthlyMetric.find_or_initialize_by(startup: startup, period: period)
  mm.user = user
  mm.mrr = mrr
  mm.customers = customers
  mm.new_paying_customers = (period == start_period ? 0 : [ (customers * growth_pct).round, 1 ].max)
  mm.churned_customers = (period == start_period ? 0 : (customers * churn_pct).round)
  mm.cash_at_hand = cash
  mm.burn_rate = burn
  mm.is_projection = false
  mm.save!(validate: false)
  created << mm
  period = (period >> 1) # next month
end

puts "Seeded #{created.size} monthly_metrics for startup id=#{startup.id} (user id=#{user.id})"
