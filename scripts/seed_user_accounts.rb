# seeds accounts for local testing
begin
  founder_email = 'foundert@email.com'
  founder_password = 'passWord$'
  mentor_email = 'mentort@email.com'
  mentor_password = 'passWord$'

  u = User.find_or_initialize_by(email: founder_email)
  u.password = founder_password
  u.password_confirmation = founder_password
  u.role = 'founder' if u.respond_to?(:role)
  u.save!
  puts "Created/updated founder user: #{u.email} (id=#{u.id})"

  # create startup_profile if table exists
  if defined?(StartupProfile) && ActiveRecord::Base.connection.data_source_exists?('startup_profiles')
    unless u.startup_profile
      sp = StartupProfile.new(
        user: u,
        startup_name: 'Seeded Founder Startup',
        description: 'This is a seeded test startup profile.',
        stage: 'early',
        sector: 'Technology',
        target_market: 'Local',
        value_proposition: 'Test value proposition',
        funding_stage: 'pre_seed'
      )
      sp.save!(validate: false)
      puts 'Created StartupProfile for founder'
    else
      puts 'Founder already has a StartupProfile'
    end
  else
    puts 'No StartupProfile model/table — skipped.'
  end

  m = User.find_or_initialize_by(email: mentor_email)
  m.password = mentor_password
  m.password_confirmation = mentor_password
  m.role = 'mentor' if m.respond_to?(:role)
  m.save!
  puts "Created/updated mentor user: #{m.email} (id=#{m.id})"

  if defined?(Mentor) && ActiveRecord::Base.connection.data_source_exists?('mentors')
    unless Mentor.exists?(user_id: m.id)
      mm = Mentor.new(user: m)
      mm.save!(validate: false)
      puts 'Created Mentor record'
    else
      puts 'Mentor record already exists for user'
    end
  else
    puts 'No Mentor model/table — skipped.'
  end

rescue => e
  puts "Error: #{e.class} - #{e.message}"
  puts e.backtrace.join("\n")
  exit 1
end
