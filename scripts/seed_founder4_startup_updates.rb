user = User.find_by(slug: 'founder4-test-nailab-app')
unless user
  puts 'founder4 user not found'
  exit
end
startup = Startup.find_by(user_id: user.id)
unless startup
  puts 'startup not found for founder4'
  exit
end
created = 0
MonthlyMetric.where(startup_id: startup.id).order(period: :asc).each do |mm|
  next unless mm.period
  report_month = mm.period.month
  report_year = mm.period.year
  su = StartupUpdate.find_or_initialize_by(startup_id: startup.id, report_month: report_month, report_year: report_year)
  su.mrr = mm.mrr
  su.new_paying_customers = mm.new_paying_customers || mm.customers
  su.churned_customers = mm.churned_customers || 0
  su.cash_at_hand = mm.cash_at_hand
  su.burn_rate = mm.burn_rate
  su.funds_raised = mm.funds_raised
  su.report_month = report_month
  su.report_year = report_year
  su.save! if su.new_record?
  created += 1 if su.persisted?
end
puts "Created or ensured #{created} StartupUpdate records for founder4"
