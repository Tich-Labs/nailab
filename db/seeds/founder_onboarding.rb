# db/seeds/founder_onboarding.rb
# Seed UserProfile and StartupProfile for each founder
require 'faker'

User.founders.find_each do |founder|
  founder.create_user_profile!(
    full_name: Faker::Name.name,
    phone: Faker::PhoneNumber.cell_phone,
    country: Faker::Address.country,
    city: Faker::Address.city,
    bio: Faker::Lorem.sentence(word_count: 20),
    title: "Founder & CEO",
    organization: Faker::Company.name,
    linkedin_url: Faker::Internet.url(host: 'linkedin.com'),
    onboarding_completed: true
  ) unless founder.user_profile

  founder.create_startup_profile!(
    startup_name: Faker::Company.name,
    description: Faker::Company.catch_phrase,
    stage: ["Idea/Concept", "Prototype", "Pilot", "Traction", "Scaling"].sample,
    target_market: Faker::Lorem.sentence(word_count: 10),
    value_proposition: Faker::Lorem.sentence(word_count: 12),
    sector: ["Fintech", "Healthtech", "Agritech", "Edutech", "Cleantech"].sample,
    funding_stage: ["Bootstrapped", "Seed", "Series A"].sample,
    funding_raised: rand(0..500_000),
    team_members: [
      {"name" => Faker::Name.name, "role" => "CTO"},
      {"name" => Faker::Name.name, "role" => "COO"}
    ],
    founded_year: rand(2015..2024),
    mentorship_areas: ["Product-market fit", "Go-to-market planning and launch"],
    challenge_details: Faker::Lorem.sentence(word_count: 15),
    website_url: Faker::Internet.url(host: 'startup.com'),
    profile_visibility: true
  ) unless founder.startup_profile
end

puts "Seeded UserProfile and StartupProfile for all founders."
