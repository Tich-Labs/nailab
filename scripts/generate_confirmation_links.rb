emails = [ 'foundert@email.com', 'mentort@email.com' ]

emails.each do |email|
  user = User.find_by(email: email)
  if user.nil?
    puts "User not found: #{email}"
    next
  end
  if user.confirmed?
    puts "Already confirmed: #{email}"
    next
  end
  raw, enc = Devise.token_generator.generate(User, :confirmation_token)
  user.confirmation_token = enc
  user.confirmation_sent_at = Time.now
  user.save!(validate: false)
  url = "http://127.0.0.1:3000/users/confirmation?confirmation_token=#{raw}"
  puts "Confirmation URL for #{email}:"
  puts url
end
