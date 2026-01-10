# Script to create test founder and mentor users and associated records
begin
  u = User.find_or_initialize_by(email: 'founder@example.com')
  u.password = 'password'
  u.password_confirmation = 'password'
  u.role = 'founder' if u.respond_to?(:role)
  u.save!
  puts "Founder user: #{u.email} (id=#{u.id})"
  if defined?(Founder) && ActiveRecord::Base.connection.data_source_exists?('founders')
    unless Founder.exists?(user_id: u.id)
      f = Founder.new(user: u)
      f.save!(validate: false)
      puts 'Created Founder record'
    else
      puts 'Founder record already exists'
    end
  else
    puts 'Founder model or table not present — skipping Founder record creation'
  end

  m = User.find_or_initialize_by(email: 'mentor@example.com')
  m.password = 'password'
  m.password_confirmation = 'password'
  m.role = 'mentor' if m.respond_to?(:role)
  m.save!
  puts "Mentor user: #{m.email} (id=#{m.id})"
  if defined?(Mentor) && ActiveRecord::Base.connection.data_source_exists?('mentors')
    unless Mentor.exists?(user_id: m.id)
      mm = Mentor.new(user: m)
      mm.save!(validate: false)
      puts 'Created Mentor record'
    else
      puts 'Mentor record already exists'
    end
  else
    puts 'Mentor model or table not present — skipping Mentor record creation'
  end
rescue => e
  puts "Error: #{e.class} - #{e.message}"
  puts e.backtrace.join("\n")
  exit 1
end
