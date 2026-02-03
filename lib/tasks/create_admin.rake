namespace :admin do
  desc "Create or promote an admin user. Use ADMIN_EMAIL and ADMIN_PASSWORD env vars. If no password provided, a secure one will be generated and printed."
  task create: :environment do
    require "securerandom"

    email = ENV.fetch("ADMIN_EMAIL", nil)
    unless email && email.include?("@")
      puts "ERROR: set ADMIN_EMAIL (e.g. ADMIN_EMAIL=mary@nailab.co.ke)"
      exit 1
    end

    password = ENV["ADMIN_PASSWORD"]
    generated = false
    if password.blank?
      password = SecureRandom.urlsafe_base64(12)
      generated = true
    end

    u = User.find_or_initialize_by(email: email.downcase.strip)
    if u.new_record?
      u.password = password
      u.password_confirmation = password
    else
      # Only overwrite password if ADMIN_FORCE_PASSWORD=1 is set
      if ENV["ADMIN_FORCE_PASSWORD"] == "1"
        u.password = password
        u.password_confirmation = password
      end
    end

    u.role = :admin
    u.admin = true if u.respond_to?(:admin=)
    if u.respond_to?(:confirmed_at) && u.confirmed_at.blank?
      u.confirmed_at = Time.current
    end

    u.save!

    if generated
      puts "Admin user created/promoted: #{u.email}"
      puts "Generated password: #{password}"
      puts "Please log in and change the password immediately."
    else
      puts "Admin user created/promoted: #{u.email} (password unchanged unless ADMIN_FORCE_PASSWORD=1)"
    end
  end
end
