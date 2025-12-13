# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
Startup.find_or_create_by!(name: "EcoHub") do |startup|
  startup.description = "A startup focused on sustainability."
  startup.website = "https://ecohub.com"
  startup.industry = "Sustainability"
  startup.founded_on = "2021-03-12"
  startup.approved = true
end

Mentor.find_or_create_by!(email: "jane@example.com") do |mentor|
  mentor.name = "Jane Doe"
  mentor.bio = "Startup mentor with 10+ years experience."
  mentor.expertise = "Product, Strategy"
  mentor.approved = true
  mentor.available = true
  mentor.years_experience = 12
  mentor.current_affiliation = "AfriTech Ventures"
  mentor.advisor_or_investor = true
  mentor.mentorship_industries = "Fintech, Healthtech, E-commerce"
  mentor.mentorship_areas = "Product Development, Go-to-Market, Strategy"
  mentor.preferred_stage = "Growth"
  mentor.availability_hours_per_month = 8
  mentor.mentorship_approach = "Hands-on guidance with actionable feedback and strategic insights"
  mentor.motivation = "Giving back to the African startup ecosystem and helping the next generation of entrepreneurs succeed"
  mentor.mentorship_mode = "Virtual"
  mentor.hourly_rate = 75.0
  mentor.linkedin_url = "https://linkedin.com/in/janedoe"
  mentor.website_url = "https://janedoementor.com"
end

Mentor.find_or_create_by!(email: "john@example.com") do |mentor|
  mentor.name = "John Smith"
  mentor.bio = "Serial entrepreneur and angel investor specializing in fintech and healthtech."
  mentor.expertise = "Fundraising, Fintech, Healthtech"
  mentor.approved = true
end

Mentor.find_or_create_by!(email: "sarah@example.com") do |mentor|
  mentor.name = "Sarah Johnson"
  mentor.bio = "Former CTO at a unicorn startup, expert in scaling engineering teams."
  mentor.expertise = "Engineering, Team Building, Scaling"
  mentor.approved = true
end

Mentor.find_or_create_by!(email: "michael@example.com") do |mentor|
  mentor.name = "Michael Chen"
  mentor.bio = "Marketing strategist with experience launching products in competitive markets."
  mentor.expertise = "Marketing, Growth, Product Launch"
  mentor.approved = true
end

# Mentor Applications
MentorApplication.find_or_create_by!(email: "sarah.johnson@example.com") do |app|
  app.full_name = "Sarah Johnson"
  app.short_bio = "Former CTO with 8 years experience scaling engineering teams."
  app.current_role = "Engineering Director"
  app.experience_years = :six_ten
  app.has_advisory_experience = true
  app.organization = "TechCorp"
  app.industries = ["Technology", "SaaS", "FinTech"]
  app.mentorship_topics = ["Team Building", "Scaling", "Product Development"]
  app.preferred_stages = :growth
  app.availability_hours = :monthly_6_10
  app.approach = "Hands-on guidance with regular check-ins and strategic planning."
  app.motivation = "Passionate about helping African startups overcome technical challenges."
  app.mode = :virtual
  app.rate = 150.0
  app.linkedin_url = "https://linkedin.com/in/sarahjohnson"
  app.status = :pending
end

MentorApplication.find_or_create_by!(email: "david.kamau@example.com") do |app|
  app.full_name = "David Kamau"
  app.short_bio = "Serial entrepreneur and angel investor in East African tech ecosystem."
  app.current_role = "CEO & Founder"
  app.experience_years = :over_ten
  app.has_advisory_experience = true
  app.organization = "Savanna Ventures"
  app.industries = ["Technology", "E-commerce", "Agriculture"]
  app.mentorship_topics = ["Fundraising", "Go-to-Market", "Operations"]
  app.preferred_stages = :early
  app.availability_hours = :monthly_3_5
  app.approach = "Focus on practical strategies and network connections."
  app.motivation = "Building the next generation of African tech leaders."
  app.mode = :both
  app.rate = 200.0
  app.linkedin_url = "https://linkedin.com/in/davidkamau"
  app.status = :approved
end

Event.create!(
  title: "Startup Demo Day",
  description: "Pitch event for early-stage startups.",
  date: Date.today + 30,
  location: "Nairobi Innovation Hub",
  registration_url: "https://example.com/register"
)

BlogPost.create!(
  title: "How to Scale an Early Startup",
  published_on: Date.today
).tap do |post|
  post.body = "This is a sample blog post content created for development."
end

Opportunity.create!(
  title: "Seed Funding Opportunity",
  description: "Funding opportunity for African startups.",
  url: "https://example.com/opportunity",
  deadline: Date.today + 60
)

TemplateGuide.create!(
  title: "Startup Pitch Deck Template",
  category: "Fundraising",
  description: "A comprehensive template for creating compelling startup pitch decks to attract investors and partners."
)

# Create sample users for mentorship requests
user1 = User.find_or_create_by!(email: "alice.founder@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

user2 = User.find_or_create_by!(email: "bob.entrepreneur@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

user3 = User.find_or_create_by!(email: "carol.startup@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

user4 = User.find_or_create_by!(email: "david.innovator@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

user5 = User.find_or_create_by!(email: "eve.ceo@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

user6 = User.find_or_create_by!(email: "frank.founder@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

user7 = User.find_or_create_by!(email: "grace.entrepreneur@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

user8 = User.find_or_create_by!(email: "henry.startup@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

user9 = User.find_or_create_by!(email: "iris.innovator@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

user10 = User.find_or_create_by!(email: "jack.ceo@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

# Create approved one-time mentorship requests
MentorshipRequest.find_or_create_by!(user: user1, request_type: :one_time) do |request|
  request.topic = "Product-Market Fit Validation"
  request.date = Date.today + 14
  request.goal = "Get feedback on our MVP from an experienced product manager"
  request.status = :approved
end

MentorshipRequest.find_or_create_by!(user: user2, request_type: :one_time) do |request|
  request.topic = "Fundraising Strategy"
  request.date = Date.today + 21
  request.goal = "Learn how to prepare for seed round fundraising"
  request.status = :approved
end

MentorshipRequest.find_or_create_by!(user: user3, request_type: :one_time) do |request|
  request.topic = "Team Building and Hiring"
  request.date = Date.today + 7
  request.goal = "Advice on building a strong founding team"
  request.status = :approved
end

MentorshipRequest.find_or_create_by!(user: user4, request_type: :one_time) do |request|
  request.topic = "Go-to-Market Strategy"
  request.date = Date.today + 28
  request.goal = "Develop a comprehensive launch plan for our SaaS product"
  request.status = :approved
end

MentorshipRequest.find_or_create_by!(user: user5, request_type: :one_time) do |request|
  request.topic = "Customer Acquisition"
  request.date = Date.today + 10
  request.goal = "Strategies for acquiring first 100 paying customers"
  request.status = :approved
end

# Create approved ongoing mentorship requests
MentorshipRequest.find_or_create_by!(user: user6, request_type: :ongoing) do |request|
  request.full_name = "Frank Johnson"
  request.phone_number = "+254 712 345 678"
  request.startup_name = "AgriTech Solutions"
  request.startup_bio = "Revolutionizing agriculture through IoT sensors and data analytics to help smallholder farmers optimize crop yields and reduce waste."
  request.startup_stage = :mvp
  request.startup_industry = "AgriTech"
  request.funding_structure = "Bootstrapped"
  request.total_funding = "$50,000"
  request.target_market = "Smallholder farmers in East Africa aged 25-55 with 1-5 acre farms, facing challenges with unpredictable weather patterns and limited access to modern farming technology."
  request.mentorship_needs = "Need guidance on scaling our MVP to multiple regions, developing partnerships with agricultural cooperatives, and navigating regulatory requirements for agricultural technology in Kenya."
  request.preferred_mentorship_mode = "virtual"
  request.top_mentorship_areas = "Go-to-market,Fundraising,Team building"
  request.commitment_length = "6_months"
  request.status = :approved
end

MentorshipRequest.find_or_create_by!(user: user7, request_type: :ongoing) do |request|
  request.full_name = "Grace Chen"
  request.phone_number = "+254 723 456 789"
  request.startup_name = "HealthConnect"
  request.startup_bio = "Digital health platform connecting patients with healthcare providers through telemedicine and health record management."
  request.startup_stage = :early_traction
  request.startup_industry = "HealthTech"
  request.funding_structure = "Pre-seed"
  request.total_funding = "$150,000"
  request.target_market = "Urban and peri-urban residents in Nairobi and surrounding areas seeking convenient healthcare access, particularly young professionals and families."
  request.mentorship_needs = "Looking for mentorship in regulatory compliance for health data, building trust with healthcare providers, and scaling user acquisition through partnerships."
  request.preferred_mentorship_mode = "in_person"
  request.top_mentorship_areas = "Legal,Fundraising,Branding"
  request.commitment_length = "12_months"
  request.status = :approved
end

MentorshipRequest.find_or_create_by!(user: user8, request_type: :ongoing) do |request|
  request.full_name = "Henry Oduya"
  request.phone_number = "+254 734 567 890"
  request.startup_name = "EduLearn"
  request.startup_bio = "AI-powered personalized learning platform adapting to individual student needs and learning styles."
  request.startup_stage = :growth
  request.startup_industry = "EdTech"
  request.funding_structure = "Series A"
  request.total_funding = "$2.5M"
  request.target_market = "Students aged 13-18 in secondary schools across East Africa, parents interested in quality education, and schools looking to improve learning outcomes."
  request.mentorship_needs = "Need strategic guidance on international expansion, curriculum development partnerships, and navigating education regulatory frameworks."
  request.preferred_mentorship_mode = "virtual"
  request.top_mentorship_areas = "Go-to-market,Fundraising,Legal"
  request.commitment_length = "12_months"
  request.status = :approved
end

MentorshipRequest.find_or_create_by!(user: user9, request_type: :ongoing) do |request|
  request.full_name = "Iris Wanjiku"
  request.phone_number = "+254 745 678 901"
  request.startup_name = "GreenCommerce"
  request.startup_bio = "E-commerce platform specializing in sustainable and locally-sourced products, connecting artisans with conscious consumers."
  request.startup_stage = :idea
  request.startup_industry = "E-commerce"
  request.funding_structure = "Bootstrapped"
  request.total_funding = "$25,000"
  request.target_market = "Environmentally conscious consumers aged 25-45 in urban areas, looking for sustainable lifestyle products and supporting local artisans."
  request.mentorship_needs = "Seeking mentorship in building supplier networks, developing a unique value proposition in the crowded e-commerce space, and marketing strategies for sustainable products."
  request.preferred_mentorship_mode = "group"
  request.top_mentorship_areas = "Branding,Go-to-market,Fundraising"
  request.commitment_length = "3_months"
  request.status = :approved
end

MentorshipRequest.find_or_create_by!(user: user10, request_type: :ongoing) do |request|
  request.full_name = "Jack Mwangi"
  request.phone_number = "+254 756 789 012"
  request.startup_name = "FinAccess"
  request.startup_bio = "Financial inclusion platform providing micro-loans and savings products to underserved communities through mobile technology."
  request.startup_stage = :scaling
  request.startup_industry = "FinTech"
  request.funding_structure = "Series A"
  request.total_funding = "$4.2M"
  request.target_market = "Low-to-middle income individuals in rural and urban areas across East Africa who lack access to traditional banking services."
  request.mentorship_needs = "Need guidance on regulatory compliance in financial services, risk management for microfinance, and scaling operations across multiple countries."
  request.preferred_mentorship_mode = "one_on_one"
  request.top_mentorship_areas = "Legal,Fundraising,Team building"
  request.commitment_length = "12_months"
  request.status = :approved
end

AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end if Rails.env.development?

# Homepage Sections
HomepageSection.find_or_create_by!(title: "Welcome to Nailab") do |section|
  section.section_type = :hero
  section.subtitle = "Empowering African startups and entrepreneurs through mentorship, funding opportunities, and community support."
  section.cta_text = "Explore Startups"
  section.cta_url = "/startups"
  section.position = 1
  section.visible = true
end

HomepageSection.find_or_create_by!(title: "What We Offer") do |section|
  section.section_type = :features
  section.content = <<~HTML
    <div class="grid grid-cols-1 md:grid-cols-3 gap-10 max-w-6xl mx-auto text-center text-nailab-purple-dark">
      <!-- Card 1 -->
      <div class="flex flex-col items-center p-6 bg-white border border-nailab-teal-light rounded-lg shadow hover:shadow-lg transition">
        <div class="w-16 h-16 bg-nailab-teal rounded-full flex items-center justify-center mb-4" role="img" aria-label="Rocket icon for Startups">
          <span class="text-white text-3xl">🚀</span>
        </div>
        <h3 class="text-xl font-bold mb-2">Startup Directory</h3>
        <p class="text-gray-700 mb-4">Discover innovative African startups and connect with their founders.</p>
        <a href="/startups" class="text-nailab-teal font-semibold hover:text-nailab-purple transition underline focus:outline-none focus:ring-2 focus:ring-nailab-teal">Browse Startups</a>
      </div>

      <!-- Card 2 -->
      <div class="flex flex-col items-center p-6 bg-white border border-nailab-teal-light rounded-lg shadow hover:shadow-lg transition">
        <div class="w-16 h-16 bg-nailab-teal rounded-full flex items-center justify-center mb-4" role="img" aria-label="People icon for Mentorship">
          <span class="text-white text-3xl">👥</span>
        </div>
        <h3 class="text-xl font-bold mb-2">Expert Mentors</h3>
        <p class="text-gray-700 mb-4">Get guidance from experienced entrepreneurs and industry leaders.</p>
        <a href="/mentors" class="text-nailab-teal font-semibold hover:text-nailab-purple transition underline focus:outline-none focus:ring-2 focus:ring-nailab-teal">Find Mentors</a>
      </div>

      <!-- Card 3 -->
      <div class="flex flex-col items-center p-6 bg-white border border-nailab-teal-light rounded-lg shadow hover:shadow-lg transition">
        <div class="w-16 h-16 bg-nailab-teal rounded-full flex items-center justify-center mb-4" role="img" aria-label="Calendar icon for Events">
          <span class="text-white text-3xl">📅</span>
        </div>
        <h3 class="text-xl font-bold mb-2">Events & Opportunities</h3>
        <p class="text-gray-700 mb-4">Stay updated on networking events and funding opportunities.</p>
        <a href="/events" class="text-nailab-teal font-semibold hover:text-nailab-purple transition underline focus:outline-none focus:ring-2 focus:ring-nailab-teal">View Events</a>
      </div>
    </div>
  HTML
  section.position = 2
  section.visible = true
end


HomepageSection.find_or_create_by!(title: "Platform Statistics") do |section|
  section.section_type = :stats
  section.position = 3
  section.visible = true
end

HomepageSection.find_or_create_by!(title: "Why Nailab Exists") do |section|
  section.section_type = :about_snapshot
  section.content = "<p>We believe in Africa's potential to solve its most pressing challenges through entrepreneurship. Nailab supports startups by providing mentorship, access to funding opportunities, knowledge, and a vibrant network of peers and experts.</p><p>Through our initiatives, we aim to nurture innovative and impactful ideas that can scale sustainably across the continent.</p>"
  section.position = 4
  section.visible = true
end

HomepageSection.find_or_create_by!(title: "Ready to Join the Community?") do |section|
  section.section_type = :cta
  section.subtitle = "Connect with Africa's brightest startup minds and accelerate your entrepreneurial journey."
  section.cta_text = "Sign Up"
  section.cta_url = "/users/sign_up"
  section.position = 6
  section.visible = true
end

HomepageSection.find_or_create_by!(title: "Our Focus Areas") do |section|
  section.section_type = :focus_areas
  section.content = <<~HTML
    <ul class="grid grid-cols-2 md:grid-cols-4 gap-6 text-center text-nailab-purple-dark">
      <li class="flex flex-col items-center">
        <span class="text-4xl mb-2">👥</span>
        <p class="font-semibold">Mentorship</p>
      </li>
      <li class="flex flex-col items-center">
        <span class="text-4xl mb-2">💰</span>
        <p class="font-semibold">Funding Access</p>
      </li>
      <li class="flex flex-col items-center">
        <span class="text-4xl mb-2">📚</span>
        <p class="font-semibold">Resources</p>
      </li>
      <li class="flex flex-col items-center">
        <span class="text-4xl mb-2">🤝</span>
        <p class="font-semibold">Community</p>
      </li>
    </ul>
  HTML
  section.position = 5
  section.visible = true
end

Testimonial.find_or_create_by!(name: "Grace M.") do |testimonial|
  testimonial.quote = "Nailab connected me with the perfect mentor who helped me secure my first investor!"
  testimonial.visible = true
  testimonial.position = 1
end

Testimonial.find_or_create_by!(name: "Alex K.") do |testimonial|
  testimonial.quote = "The mentorship program gave me the confidence to launch my startup. Highly recommend!"
  testimonial.visible = true
  testimonial.position = 2
end

Testimonial.find_or_create_by!(name: "Sarah T.") do |testimonial|
  testimonial.quote = "Nailab's resources and community support were invaluable during our early growth phase."
  testimonial.visible = true
  testimonial.position = 3
end

Program.find_or_create_by!(title: "Make-IT Accelerator") do |program|
  program.summary = "Accelerating growth-stage tech startups in East Africa..."
  program.body = "This program supports startups with mentorship, investor access..."
  program.category = :incubation
  program.apply_link = "https://example.com/apply-makeit"
  program.position = 1
  program.visible = true
end

Program.find_or_create_by!(title: "develoPPP Venture Kenya") do |program|
  program.summary = "Funding early-stage businesses with development impact."
  program.body = "Implemented in partnership with GIZ and IGS, this program funds..."
  program.category = :funding
  program.apply_link = "https://example.com/apply-developpp"
  program.position = 2
  program.visible = true
end

Program.find_or_create_by!(title: "Let’s Hack Climate Change") do |program|
  program.summary = "Hackathon for youth to solve climate challenges."
  program.body = "Co-hosted by UNDP and Nailab to build sustainability solutions..."
  program.category = :mentorship
  program.apply_link = "https://example.com/hack-climate"
  program.position = 3
  program.visible = true
end

SiteMenuItem.find_or_create_by!(title: "Home", location: :header) do |item|
  item.path = "/"
  item.visible = true
  item.position = 0
end

SiteMenuItem.find_or_create_by!(title: "About Us", location: :header) do |item|
  item.path = "/about"
  item.visible = true
  item.position = 1
end

SiteMenuItem.find_or_create_by!(title: "Programs", location: :header) do |item|
  item.path = "/programs"
  item.visible = true
  item.position = 2
end

SiteMenuItem.find_or_create_by!(title: "Resources", location: :header) do |item|
  item.path = "/resources"
  item.visible = true
  item.position = 3
end

SiteMenuItem.find_or_create_by!(title: "Mentors", location: :header) do |item|
  item.path = "/mentors"
  item.visible = true
  item.position = 4
end

SiteMenuItem.find_or_create_by!(title: "Startups", location: :header) do |item|
  item.path = "/startups"
  item.visible = true
  item.position = 5
end

SiteMenuItem.find_or_create_by!(title: "Contact Us", location: :footer) do |item|
  item.path = "/contact"
  item.visible = true
  item.position = 7
end

SiteMenuItem.find_or_create_by!(title: "Startups", location: :footer) do |item|
  item.path = "/startups"
  item.visible = true
  item.position = 0
end

SiteMenuItem.find_or_create_by!(title: "Mentors", location: :footer) do |item|
  item.path = "/mentors"
  item.visible = true
  item.position = 1
end

SiteMenuItem.find_or_create_by!(title: "Events", location: :footer) do |item|
  item.path = "/events"
  item.visible = true
  item.position = 2
end

SiteMenuItem.find_or_create_by!(title: "Blog", location: :footer) do |item|
  item.path = "/blog_posts"
  item.visible = true
  item.position = 3
end

SiteMenuItem.find_or_create_by!(title: "Opportunities", location: :footer) do |item|
  item.path = "/opportunities"
  item.visible = true
  item.position = 4
end

SiteMenuItem.find_or_create_by!(title: "Resources", location: :footer) do |item|
  item.path = "/resources"
  item.visible = true
  item.position = 5
end

SiteMenuItem.find_or_create_by!(title: "Legal", location: :footer) do |item|
  item.path = "/legal"
  item.visible = true
  item.position = 6
end