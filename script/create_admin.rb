# script/create_admin.rb
user = User.find_or_initialize_by(email: 'admin@nailab.test')
user.password = 'Password1!'
user.password_confirmation = 'Password1!'
user.admin = true
user.confirmed_at ||= Time.current
user.save!(validate: true)
puts "ADMIN: #{user.email} (admin=#{user.admin})"
