# db/seeds/users.rb
# Seed sample founders and mentors for development/testing
require 'faker'

password = ENV.fetch("SEED_PASSWORD", "ChangeMe123!ChangeMe123!")

5.times do |i|
  email = "founder#{i+1}@example.com"
  user = User.find_or_initialize_by(email: email)
  user.password = password
  user.password_confirmation = password
  user.role = "founder"
  user.save!
end

5.times do |i|
  email = "mentor#{i+1}@example.com"
  user = User.find_or_initialize_by(email: email)
  user.password = password
  user.password_confirmation = password
  user.role = "mentor"
  user.save!
end

puts "Seeded 5 founders and 5 mentors (idempotent)."
