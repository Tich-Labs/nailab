# db/seeds.rb

# Refactor seed helpers into a module for better modularity and reusability
module SeedHelpers

  SEED_PASSWORD = ENV.fetch("SEED_PASSWORD", "ChangeMe123!ChangeMe123!")

  def self.safe_assign(record, attrs)
    allowed = record.class.column_names
    attrs.each do |k, v|
      record.public_send("#{k}=", v) if allowed.include?(k.to_s)
    end
  end
end



# Create admin user in all environments
if !AdminUser.exists?(email: 'admin@nailab.com')
  AdminUser.create!(email: 'admin@nailab.com', password: 'pa$$word@123', password_confirmation: 'pa$$word@123')
  puts "Created admin user: admin@nailab.com"
else
  admin = AdminUser.find_by(email: 'admin@nailab.com')
  admin.update!(password: 'pa$$word@123', password_confirmation: 'pa$$word@123')
  puts "Updated admin user password: admin@nailab.com"
end

# Development-only: Seed admin and editor users
if Rails.env.development?
  # Create sample admin user
  admin_user = User.find_or_create_by!(email: 'admin@nailab.com') do |user|
    user.password = SeedHelpers::SEED_PASSWORD
    user.password_confirmation = SeedHelpers::SEED_PASSWORD
    user.role = 'admin'
    user.confirmed_at = Time.current
    user.build_user_profile(
      full_name: 'Admin User',
      title: 'System Administrator',
      organization: 'NailaB',
      bio: 'Platform administrator with full system access.'
    )
  end

  # Create sample editor user
  editor_user = User.find_or_create_by!(email: 'editor@nailab.com') do |user|
    user.password = SeedHelpers::SEED_PASSWORD
    user.password_confirmation = SeedHelpers::SEED_PASSWORD
    user.role = 'editor'
    user.confirmed_at = Time.current
    user.build_user_profile(
      full_name: 'Content Editor',
      title: 'Content Manager',
      organization: 'NailaB',
      bio: 'Content editor responsible for managing marketing pages and resources.'
    )
  end

  puts "Created admin user: #{admin_user.email}"
  puts "Created editor user: #{editor_user.email}"
end

# ---
# Development-only: Seed users (founders and mentors) first
if Rails.env.development? && File.exist?(Rails.root.join('db/seeds/users.rb'))
  require Rails.root.join('db/seeds/users.rb')
end

# Development-only: Seed founder onboarding (user/startup profiles)
if Rails.env.development? && File.exist?(Rails.root.join('db/seeds/founder_onboarding.rb'))
  require Rails.root.join('db/seeds/founder_onboarding.rb')
end

# Development-only: Seed mentorship requests for admin review
if Rails.env.development? && File.exist?(Rails.root.join('db/seeds/mentorship_requests.rb'))
  require Rails.root.join('db/seeds/mentorship_requests.rb')
end


# Development-only: Seed resources (blogs, webinars, events, opportunities, templates, knowledge hub)
if Rails.env.development? && File.exist?(Rails.root.join('db/seeds/resources.rb'))
  require Rails.root.join('db/seeds/resources.rb')
end

# Seed programs (all environments)
if File.exist?(Rails.root.join('db/seeds/programs.rb'))
  require Rails.root.join('db/seeds/programs.rb')
end

# Seed sample mentors and founders (all environments)
puts "Seeding sample mentors and founders..."

# Sample Mentors
mentors_data = [
  {
    email: 'mentor1@nailab.com',
    full_name: 'Sarah Johnson',
    title: 'Senior Product Manager',
    organization: 'TechCorp',
    bio: 'Experienced product manager with 8+ years in startups. Passionate about helping founders build scalable products.',
    linkedin_url: 'https://linkedin.com/in/sarahjohnson',
    years_experience: 8,
    advisory_experience: 5,
    rate_per_hour: 150,
    availability_hours_month: 20,
    preferred_mentorship_mode: 'Video Call',
    pro_bono: false,
    sectors: ['SaaS', 'FinTech', 'E-commerce'],
    expertise: ['Product Strategy', 'User Research', 'Go-to-Market'],
    stage_preference: ['Seed', 'Series A']
  },
  {
    email: 'mentor2@nailab.com',
    full_name: 'Michael Chen',
    title: 'VP of Engineering',
    organization: 'StartupXYZ',
    bio: 'Former VP of Engineering at multiple successful startups. Expert in scaling engineering teams and technical architecture.',
    linkedin_url: 'https://linkedin.com/in/michaelchen',
    years_experience: 12,
    advisory_experience: 7,
    rate_per_hour: 200,
    availability_hours_month: 15,
    preferred_mentorship_mode: 'Video Call',
    pro_bono: true,
    sectors: ['SaaS', 'AI/ML', 'Enterprise Software'],
    expertise: ['Technical Leadership', 'System Architecture', 'Team Building'],
    stage_preference: ['Series A', 'Series B']
  }
]

mentors_data.each do |data|
  user = User.find_or_create_by!(email: data[:email]) do |u|
    u.password = SeedHelpers::SEED_PASSWORD
    u.password_confirmation = SeedHelpers::SEED_PASSWORD
    u.role = 'mentor'
    u.confirmed_at = Time.current
  end

  profile = user.user_profile || user.build_user_profile
  SeedHelpers.safe_assign(profile, data.except(:email))
  profile.save!

  puts "Created mentor: #{user.email}"
end

# Sample Founders
founders_data = [
  {
    email: 'founder1@nailab.com',
    full_name: 'Alex Rivera',
    title: 'CEO & Founder',
    organization: 'GreenTech Solutions',
    bio: 'Building sustainable technology solutions for urban farming. Previously worked at major agtech companies.',
    linkedin_url: 'https://linkedin.com/in/alexrivera',
    years_experience: 6,
    advisory_experience: 2,
    sectors: ['AgTech', 'Sustainability'],
    expertise: ['Business Development', 'Sustainability', 'Operations']
  },
  {
    email: 'founder2@nailab.com',
    full_name: 'Emma Thompson',
    title: 'CTO & Co-Founder',
    organization: 'HealthAI',
    bio: 'AI researcher turned entrepreneur. Building AI-powered healthcare solutions to improve patient outcomes.',
    linkedin_url: 'https://linkedin.com/in/emmathompson',
    years_experience: 10,
    advisory_experience: 3,
    sectors: ['HealthTech', 'AI/ML', 'Healthcare'],
    expertise: ['AI/ML', 'Healthcare', 'Product Development']
  }
]

founders_data.each do |data|
  user = User.find_or_create_by!(email: data[:email]) do |u|
    u.password = SeedHelpers::SEED_PASSWORD
    u.password_confirmation = SeedHelpers::SEED_PASSWORD
    u.role = 'founder'
    u.confirmed_at = Time.current
  end

  profile = user.user_profile || user.build_user_profile
  SeedHelpers.safe_assign(profile, data.except(:email))
  profile.save!

  # Create sample startup profile for founders
  if user.startup_profile.nil?
    user.create_startup_profile!(
      startup_name: "#{user.user_profile.full_name}'s Startup",
      sector: data[:sectors].first,
      stage: 'Seed',
      description: "A startup founded by #{user.user_profile.full_name} in the #{data[:sectors].first} sector.",
      website_url: 'https://example.com',
      funding_raised: rand(100000..500000),
      team_size: rand(2..10),
      founded_year: rand(2020..2025),
      location: ['San Francisco, CA', 'New York, NY', 'Austin, TX', 'London, UK'].sample,
      profile_visibility: true
    )
  end

  puts "Created founder: #{user.email}"
end

puts "Seeding completed!"