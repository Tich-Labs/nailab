namespace :admin do
  desc "Create or update admin user"
  task create: :environment do
    email = ENV['ADMIN_EMAIL'] || 'admin@nailab.com'
    password = ENV['ADMIN_PASSWORD'] || 'pa$$word@123'

    admin = AdminUser.find_or_create_by!(email: email) do |user|
      puts "Creating new admin user: #{email}"
    end

    admin.update!(password: password, password_confirmation: password)
    puts "Admin user #{email} password updated successfully"
  end
end