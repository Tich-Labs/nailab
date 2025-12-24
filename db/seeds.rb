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