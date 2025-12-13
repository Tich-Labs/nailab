Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
  provider :linkedin, ENV['LINKEDIN_CLIENT_ID'], ENV['LINKEDIN_CLIENT_SECRET'],
           scope: 'r_liteprofile r_emailaddress',
           fields: ['id', 'first-name', 'last-name', 'email-address', 'headline', 'public-profile-url']
end