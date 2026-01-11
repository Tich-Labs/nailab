# Creates two test founders with StartupProfile and pending UserProfile for admin testing
admin = User.find_by(email: 'admin@nailab.test') || User.where(admin: true).first
raise "No admin user found. Create an admin user first." unless admin

users = [
  { email: 'audit_founder1@example.com', full_name: 'Audit Founder One', startup: { startup_name: 'AuditCo One', slug: 'auditco-one', description: 'Audit startup one for testing', stage: 'early_stage', sector: 'Fintech', target_market: 'SMEs', value_proposition: 'Test value prop one', website_url: 'https://auditco-one.example', funding_stage: 'pre_seed', profile_visibility: false } },
  { email: 'audit_founder2@example.com', full_name: 'Audit Founder Two', startup: { startup_name: 'AuditCo Two', slug: 'auditco-two', description: 'Audit startup two for testing', stage: 'early_stage', sector: 'Healthtech', target_market: 'Clinics', value_proposition: 'Test value prop two', website_url: 'https://auditco-two.example', funding_stage: 'pre_seed', profile_visibility: false } }
]

created = []

users.each do |u|
  user = User.where(email: u[:email]).first_or_initialize
  user.password = 'Password1!'
  user.confirmed_at = Time.now if user.respond_to?(:confirmed_at)
  user.save! if user.changed? || user.new_record?

  up = user.user_profile || user.build_user_profile
  up.full_name = u[:full_name]
  up.role = 'founder'
  up.phone = '+254700000000'
  up.country = 'Kenya'
  up.bio = 'This is a short bio for audit testing purposes, longer than 30 chars.'
  up.profile_approval_status = 'pending'
  up.save!

  sp = user.startup_profile || user.build_startup_profile
  u[:startup].each { |k, v| sp.send("#{k}=", v) }
  sp.user = user
  sp.active = false if sp.respond_to?(:active)
  sp.save!

  created << { user: user, user_profile: up, startup_profile: sp }
end

puts "Created #{created.size} founders and startup_profiles:\n"
created.each do |c|
  puts "- #{c[:user].email} -> startup_profile id=#{c[:startup_profile].id} slug=#{c[:startup_profile].slug} profile_approval_status=#{c[:user_profile].profile_approval_status}"
end
