# db/seeds/mentorship_requests.rb
# Development-only: Seed 10 realistic mentorship requests for admin review

stages = ["Idea Stage", "Early Stage", "Growth Stage", "Scaling Stage"]

require 'faker'

mentorship_areas_options = [
  "Business model refinement",
  "Product-market fit",
  "Access to customers and markets",
  "Go-to-market planning and launch",
  "Product development",
  "Pitching, fundraising, and investor readiness",
  "Marketing and branding",
  "Team building and HR",
  "Budgeting and financial management",
  "Market expansion (local or regional)",
  "Legal or regulatory guidance",
  "Leadership and personal growth",
  "Strategic partnerships and collaborations",
  "Sales and customer acquisition"
]

preferred_modes = ["One-on-one Sessions", "Group Mentorship", "Virtual Mentorship", "In-person"]

founders = User.founders.to_a
mentors = User.mentors.to_a

if founders.empty? || mentors.empty?
  puts "No founders or mentors found. Please seed users first."
else
  10.times do |i|
    founder = founders.sample
    mentor = mentors.sample
    MentorshipRequest.create!(
      founder_id: founder.id,
      mentor_id: mentor.id,
      message: Faker::Lorem.paragraph(sentence_count: 2),
      areas_needed: mentorship_areas_options.sample(rand(1..3)),
      preferred_mode: preferred_modes.sample,
      status: "pending",
      created_at: rand(1..30).days.ago
    )
  end
  puts "Created 10 realistic mentorship requests for admin review!"
end
