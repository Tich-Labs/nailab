# db/seeds.rb

SEED_PASSWORD = ENV.fetch("SEED_PASSWORD", "ChangeMe123!ChangeMe123!")

def safe_assign(record, attrs)
  allowed = record.class.column_names
  attrs.each do |k, v|
    record.public_send("#{k}=", v) if allowed.include?(k.to_s)
  end
end

def link_to_owner(record, user:, startup_profile:)
  cols = record.class.column_names
  record.user_id = user.id if cols.include?("user_id")
  record.founder_id = user.id if cols.include?("founder_id")
  record.startup_profile_id = startup_profile.id if cols.include?("startup_profile_id")
  record.startup_id = startup_profile.id if cols.include?("startup_id")
end

def ensure_confirmed!(user)
  if user.respond_to?(:confirmed_at) && user.confirmed_at.blank?
    user.confirmed_at = Time.current
  end
end

def seed_founder!(email:, full_name:)
  user = User.find_or_initialize_by(email: email)
  if user.new_record?
    user.password = SEED_PASSWORD
    user.password_confirmation = SEED_PASSWORD
  end

  # If your User has name fields, this will set them safely.
  safe_assign(user, {
    name: full_name,
    full_name: full_name,
    first_name: full_name.split(" ").first,
    last_name: full_name.split(" ").last
  })

  ensure_confirmed!(user)
  user.save!
  user
end

def seed_startup_profile!(user:, attrs:)
  profile = StartupProfile.find_or_initialize_by(user_id: user.id)
  safe_assign(profile, attrs.merge(active: true))
  profile.save!
  profile
end

def seed_milestones!(user:, startup_profile:, milestones:)
  return unless defined?(Milestone)

  milestones.each do |m|
    milestone = Milestone.new
    link_to_owner(milestone, user: user, startup_profile: startup_profile)

    safe_assign(milestone, {
      title: m[:title],
      name: m[:title],
      description: m[:description],
      status: m[:status],
      due_date: m[:due_date],
      target_date: m[:due_date],
      completed_at: m[:completed_at]
    })

    milestone.save!
  end
end

def seed_monthly_metrics!(user:, startup_profile:, metrics:)
  return unless defined?(MonthlyMetric)

  metrics.each do |mm|
    metric = MonthlyMetric.new
    link_to_owner(metric, user: user, startup_profile: startup_profile)

    safe_assign(metric, {
      month: mm[:month],
      period: mm[:month],
      recorded_on: mm[:month],
      revenue: mm[:revenue],
      total_revenue: mm[:revenue],
      customers: mm[:customers],
      customer_count: mm[:customers],
      runway_months: mm[:runway_months],
      runway: mm[:runway_months],
      burn_rate: mm[:burn_rate],
      monthly_burn: mm[:burn_rate],
      notes: mm[:notes]
    })

    metric.save!
  end
end

# ----------------------------
# FOUNDER 1 — Agritech (Early Stage)
# ----------------------------
f1 = seed_founder!(email: "aisha@greensprout.africa", full_name: "Aisha Wanjiku")
s1 = seed_startup_profile!(user: f1, attrs: {
  startup_name: "GreenSprout",
  sector: "Agritech",
  stage: "early_stage",
  funding_stage: "bootstrapped",
  founded_year: 2025,
  location: "Nakuru, Kenya",
  website_url: "https://greensprout.example",
  target_market: "Smallholder farmers and agri-cooperatives in Kenya",
  team_size: "2-5",
  preferred_mentorship_mode: "virtual",
  phone_number: "+254700111222",
  mentorship_areas: "Go-to-market, partnerships, pricing, product development, ops",
  description: "Mobile advisory + supply coordination tool helping farmers plan inputs and connect to buyers.",
  value_proposition: "Reduce post-harvest losses and improve farmer margins through better planning and market access.",
  challenge_details: "Need help refining GTM, partnership strategy with cooperatives, and pricing model for sustainability."
})

seed_milestones!(
  user: f1,
  startup_profile: s1,
  milestones: [
    { title: "Pilot with 3 cooperatives", description: "Run a 6-week pilot with 150 farmers across 3 cooperatives.", status: "in_progress", due_date: Date.today + 30 },
    { title: "Launch v1 advisory module", description: "Release core advisory flows + SMS reminders.", status: "planned", due_date: Date.today + 60 },
    { title: "Secure 1 anchor buyer", description: "Sign one buyer agreement for off-take.", status: "planned", due_date: Date.today + 90 }
  ]
)

seed_monthly_metrics!(
  user: f1,
  startup_profile: s1,
  metrics: [
    { month: Date.new(2025, 7, 1), revenue: 0,    customers: 25, runway_months: 3, burn_rate: 35000, notes: "MVP pilots started." },
    { month: Date.new(2025, 8, 1), revenue: 8000, customers: 60, runway_months: 3, burn_rate: 42000, notes: "Added 2 cooperatives." },
    { month: Date.new(2025, 9, 1), revenue: 15000, customers: 110, runway_months: 2, burn_rate: 55000, notes: "Field ops expanded." },
    { month: Date.new(2025,10, 1), revenue: 23000, customers: 160, runway_months: 2, burn_rate: 60000, notes: "Improved retention." },
    { month: Date.new(2025,11, 1), revenue: 35000, customers: 210, runway_months: 2, burn_rate: 62000, notes: "Tested subscription tiers." },
    { month: Date.new(2025,12, 1), revenue: 48000, customers: 280, runway_months: 2, burn_rate: 65000, notes: "Preparing for buyer partnership." }
  ]
)

# ----------------------------
# FOUNDER 2 — Healthtech (Early Stage)
# ----------------------------
f2 = seed_founder!(email: "brian@clinicflow.health", full_name: "Brian Ochieng")
s2 = seed_startup_profile!(user: f2, attrs: {
  startup_name: "ClinicFlow",
  sector: "Healthtech",
  stage: "early_stage",
  funding_stage: "pre_seed",
  founded_year: 2024,
  location: "Kisumu, Kenya",
  website_url: "https://clinicflow.example",
  target_market: "Private clinics and pharmacies in Western Kenya",
  team_size: "2-5",
  preferred_mentorship_mode: "both",
  phone_number: "+254700333444",
  mentorship_areas: "PMF, product strategy, B2B sales, compliance, hiring",
  description: "A lightweight clinic operations tool for patient flow, inventory, and basic reporting.",
  value_proposition: "Cut waiting time and reduce stockouts for small clinics with an affordable workflow system.",
  challenge_details: "Need mentorship on PMF validation, B2B sales playbook, and compliance pathway."
})

seed_milestones!(
  user: f2,
  startup_profile: s2,
  milestones: [
    { title: "Close 10 paying clinics", description: "Convert pilots to paid subscriptions (KES monthly).", status: "in_progress", due_date: Date.today + 45 },
    { title: "Add inventory + stock alerts", description: "Implement low-stock notifications and reorder list.", status: "planned", due_date: Date.today + 75 },
    { title: "Standardize onboarding", description: "Create a repeatable onboarding checklist + templates.", status: "planned", due_date: Date.today + 90 }
  ]
)

seed_monthly_metrics!(
  user: f2,
  startup_profile: s2,
  metrics: [
    { month: Date.new(2025, 7, 1), revenue: 20000, customers: 3, runway_months: 4, burn_rate: 70000, notes: "First paid clinics." },
    { month: Date.new(2025, 8, 1), revenue: 35000, customers: 5, runway_months: 4, burn_rate: 75000, notes: "Referrals started." },
    { month: Date.new(2025, 9, 1), revenue: 50000, customers: 7, runway_months: 3, burn_rate: 90000, notes: "Support load increased." },
    { month: Date.new(2025,10, 1), revenue: 65000, customers: 9, runway_months: 3, burn_rate: 95000, notes: "Added training sessions." },
    { month: Date.new(2025,11, 1), revenue: 82000, customers: 12, runway_months: 3, burn_rate: 98000, notes: "New pricing tier tested." },
    { month: Date.new(2025,12, 1), revenue: 100000, customers: 15, runway_months: 3, burn_rate: 105000, notes: "Pipeline building." }
  ]
)

# ----------------------------
# FOUNDER 3 — Fintech/SME tools (Early Stage)
# ----------------------------
f3 = seed_founder!(email: "leila@pocketledger.io", full_name: "Leila Hassan")
s3 = seed_startup_profile!(user: f3, attrs: {
  startup_name: "PocketLedger",
  sector: "Fintech / SME Tools",
  stage: "early_stage",
  funding_stage: "bootstrapped",
  founded_year: 2025,
  location: "Nairobi, Kenya",
  website_url: "https://pocketledger.example",
  target_market: "Micro and small businesses (retail + services) in urban Kenya",
  team_size: "1-2",
  preferred_mentorship_mode: "virtual",
  phone_number: "+254700555666",
  mentorship_areas: "Pricing, product roadmap, partnerships, customer acquisition, retention",
  description: "A simple bookkeeping + cashflow tracker designed for mobile-first SMEs.",
  value_proposition: "Help SMEs understand cashflow and reduce financial stress with simple daily tracking.",
  challenge_details: "Need mentorship on distribution partnerships, retention loops, and scaling from MVP to v1."
})

seed_milestones!(
  user: f3,
  startup_profile: s3,
  milestones: [
    { title: "Ship v1 cashflow dashboard", description: "Weekly and monthly summaries + alerts.", status: "in_progress", due_date: Date.today + 35 },
    { title: "Partner with 2 business communities", description: "Distribution via SME groups/associations.", status: "planned", due_date: Date.today + 70 },
    { title: "Reach 1,000 active users", description: "Hit 1,000 monthly active users with retention ≥ 25%.", status: "planned", due_date: Date.today + 100 }
  ]
)

seed_monthly_metrics!(
  user: f3,
  startup_profile: s3,
  metrics: [
    { month: Date.new(2025, 7, 1), revenue: 0,    customers: 80, runway_months: 5, burn_rate: 25000, notes: "Free beta users." },
    { month: Date.new(2025, 8, 1), revenue: 5000, customers: 140, runway_months: 5, burn_rate: 28000, notes: "Started paid test." },
    { month: Date.new(2025, 9, 1), revenue: 12000, customers: 220, runway_months: 4, burn_rate: 35000, notes: "Added reminders." },
    { month: Date.new(2025,10, 1), revenue: 18000, customers: 320, runway_months: 4, burn_rate: 40000, notes: "Referral loop introduced." },
    { month: Date.new(2025,11, 1), revenue: 26000, customers: 450, runway_months: 4, burn_rate: 42000, notes: "Improved onboarding." },
    { month: Date.new(2025,12, 1), revenue: 40000, customers: 620, runway_months: 4, burn_rate: 45000, notes: "Preparing partnerships." }
  ]
)

puts "✅ Seeded 3 founders + startup profiles + milestones + monthly metrics."

# Seed hero slides
puts "🌱 Seeding hero slides..."
hero_slides_data = [
  {
    title: "Africa's Startup Network",
    subtitle: "Connecting founders with mentors, programs, and capital across Africa's most promising industries.",
    image_url: "https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=1200",
    cta_text: "Join the Network",
    cta_link: "/signup",
    display_order: 1
  },
  {
    title: "Accelerate Your Growth",
    subtitle: "Access world-class mentorship, strategic programs, and investor connections to scale your startup.",
    image_url: "https://images.pexels.com/photos/3184430/pexels-photo-3184430.jpeg?auto=compress&cs=tinysrgb&w=1200",
    cta_text: "Browse Programs",
    cta_link: "/programs",
    display_order: 2
  },
  {
    title: "Build the Future",
    subtitle: "Join a thriving community of African innovators driving economic growth and social impact.",
    image_url: "https://images.pexels.com/photos/3184325/pexels-photo-3184325.jpeg?auto=compress&cs=tinysrgb&w=1200",
    cta_text: "Find Mentors",
    cta_link: "/mentors",
    display_order: 3
  }
]

hero_slides_data.each do |data|
  hero_slide = HeroSlide.find_or_initialize_by(title: data[:title])
  hero_slide.assign_attributes(data)
  hero_slide.save!
end

# Seed focus areas
puts "🌱 Seeding focus areas..."
focus_areas_data = [
  {
    title: "Healthcare",
    description: "Supporting startups building solutions for healthcare access, telemedicine, and medical technology across Africa.",
    icon: "health",
    display_order: 1
  },
  {
    title: "Agriculture",
    description: "Empowering agtech startups solving food security, supply chain, and farmer productivity challenges.",
    icon: "agriculture",
    display_order: 2
  },
  {
    title: "Fintech",
    description: "Accelerating financial inclusion through payments, lending, insurance, and financial management solutions.",
    icon: "fintech",
    display_order: 3
  },
  {
    title: "Education",
    description: "Building the next generation of edtech solutions for learning access and educational equity.",
    icon: "education",
    display_order: 4
  },
  {
    title: "Logistics",
    description: "Streamlining supply chains and transportation solutions for African markets and global trade.",
    icon: "logistics",
    display_order: 5
  },
  {
    title: "Energy",
    description: "Developing clean energy and sustainable power solutions for Africa's growing energy needs.",
    icon: "energy",
    display_order: 6
  }
]

focus_areas_data.each do |data|
  focus_area = FocusArea.find_or_initialize_by(title: data[:title])
  focus_area.assign_attributes(data)
  focus_area.save!
end

# Seed testimonials
puts "🌱 Seeding testimonials..."
testimonials_data = [
  {
    author_name: "Sarah Johnson",
    author_role: "Founder & CEO",
    organization: "TechSavvy Solutions",
    quote: "Nailab provided the mentorship and network that helped us secure our Series A funding. The guidance on product-market fit was invaluable.",
    display_order: 1
  },
  {
    author_name: "Michael Chen",
    author_role: "Co-founder",
    organization: "AgriTech Innovations",
    quote: "Through Nailab's programs, we connected with key partners in East Africa. Their accelerator program transformed our go-to-market strategy.",
    display_order: 2
  },
  {
    author_name: "Amara Okafor",
    author_role: "Founder",
    organization: "HealthBridge Medical",
    quote: "The mentorship from Nailab's network helped us navigate regulatory challenges and scale our telemedicine platform across Nigeria.",
    display_order: 3
  }
]

testimonials_data.each do |data|
  testimonial = Testimonial.find_or_initialize_by(author_name: data[:author_name])
  testimonial.assign_attributes(data)
  testimonial.save!
end

# Seed partners
puts "🌱 Seeding partners..."
partners_data = [
  {
    name: "Google for Startups",
    logo_url: "https://via.placeholder.com/200x100/4285F4/FFFFFF?text=Google",
    website_url: "https://startup.google.com",
    display_order: 1
  },
  {
    name: "Microsoft for Startups",
    logo_url: "https://via.placeholder.com/200x100/00BCF2/FFFFFF?text=Microsoft",
    website_url: "https://startups.microsoft.com",
    display_order: 2
  },
  {
    name: "Y Combinator",
    logo_url: "https://via.placeholder.com/200x100/F0652F/FFFFFF?text=YC",
    website_url: "https://www.ycombinator.com",
    display_order: 3
  },
  {
    name: "African Development Bank",
    logo_url: "https://via.placeholder.com/200x100/0066CC/FFFFFF?text=AfDB",
    website_url: "https://www.afdb.org",
    display_order: 4
  },
  {
    name: "World Bank",
    logo_url: "https://via.placeholder.com/200x100/009639/FFFFFF?text=World+Bank",
    website_url: "https://www.worldbank.org",
    display_order: 5
  },
  {
    name: "IFC",
    logo_url: "https://via.placeholder.com/200x100/0066CC/FFFFFF?text=IFC",
    website_url: "https://www.ifc.org",
    display_order: 6
  }
]

partners_data.each do |data|
  partner = Partner.find_or_initialize_by(name: data[:name])
  partner.assign_attributes(data)
  partner.save!
end

puts "✅ Seeded testimonials and partners."

# Seed mentors
puts "🌱 Seeding mentors..."
mentors_data = [
  {
    email: "sarah.kennedy@nailab.mentors",
    full_name: "Sarah Kennedy",
    bio: "Former COO of Flutterwave with 8+ years in fintech operations and scaling. Passionate about helping African startups navigate growth challenges.",
    title: "Former COO, Flutterwave",
    organization: "Flutterwave",
    years_experience: 10,
    advisory_experience: 5,
    advisory_description: "Led operations for a $2B fintech unicorn, scaled from 50 to 500+ employees across 5 countries.",
    sectors: ["fintech", "payments"],
    expertise: ["operations", "scaling", "team-building"],
    stage_preference: ["growth", "scale"],
    mentorship_approach: "Structured and results-oriented, combining strategic guidance with practical implementation plans. I believe in setting clear milestones and accountability while providing the tools and frameworks needed for rapid execution. My approach focuses on building scalable systems and processes that founders can implement immediately, rather than just theoretical advice. I work closely with founders to identify their biggest bottlenecks and create actionable plans to overcome them, drawing from my experience scaling operations across multiple African markets.",
    motivation: "Giving back to the African startup ecosystem that shaped my career.",
    availability_hours_month: 10,
    preferred_mentorship_mode: "virtual",
    rate_per_hour: 150,
    pro_bono: false,
    linkedin_url: "https://linkedin.com/in/sarah-kennedy-africa",
    professional_website: "https://sarahkennedy.africa",
    currency: "USD"
  },
  {
    email: "amara.diallo@nailab.mentors",
    full_name: "Amara Diallo",
    bio: "Healthcare entrepreneur and investor. Founded two successful healthtech startups in West Africa. Expert in healthcare regulations and market entry.",
    title: "Founder & CEO, HealthBridge Africa",
    organization: "HealthBridge Africa",
    years_experience: 12,
    advisory_experience: 7,
    advisory_description: "Built and exited two healthtech companies, raised $15M+ in funding, and now invest in early-stage healthcare startups.",
    sectors: ["healthcare", "healthtech"],
    expertise: ["regulatory", "fundraising", "market-entry"],
    stage_preference: ["mvp", "growth"],
    mentorship_approach: "Empathetic and patient, focusing on sustainable growth and founder well-being. Healthcare is a unique sector with complex regulatory and ethical considerations, so I prioritize understanding each founder's vision while ensuring they build compliant, ethical businesses. My mentorship style involves regular check-ins, honest feedback, and connecting founders with the right healthcare stakeholders. I believe in building long-term relationships that extend beyond just business advice to include personal development and work-life balance in the demanding healthcare entrepreneurship space.",
    motivation: "Healthcare is personal - I want to ensure more Africans have access to quality care through entrepreneurship.",
    availability_hours_month: 8,
    preferred_mentorship_mode: "hybrid",
    rate_per_hour: 120,
    pro_bono: true,
    linkedin_url: "https://linkedin.com/in/amara-diallo-health",
    professional_website: "https://healthbridge.africa",
    currency: "USD"
  },
  {
    email: "david.mwangi@nailab.mentors",
    full_name: "David Mwangi",
    bio: "Serial entrepreneur and angel investor. Built and sold three software companies. Specializes in B2B SaaS and enterprise sales.",
    title: "Founder, SaaS Ventures Kenya",
    organization: "SaaS Ventures Kenya",
    years_experience: 15,
    advisory_experience: 8,
    advisory_description: "Founded three B2B SaaS companies, achieved 3 successful exits, and invested in 20+ African startups.",
    sectors: ["saas", "enterprise-software"],
    expertise: ["sales", "enterprise", "product-market-fit"],
    stage_preference: ["mvp", "growth", "scale"],
    mentorship_approach: "Direct and challenging, pushing founders to think bigger and execute faster. I don't believe in sugarcoating feedback - African startups need to compete globally from day one. My approach involves setting ambitious goals, holding founders accountable, and providing the tactical advice needed to achieve rapid growth. I focus on revenue generation, customer acquisition, and building defensible business models. While I'm direct, I'm also supportive and will roll up my sleeves to help with execution when needed, drawing from my experience building and selling multiple software companies.",
    motivation: "Africa needs more world-class software companies, and I'm here to help build them.",
    availability_hours_month: 12,
    preferred_mentorship_mode: "virtual",
    rate_per_hour: 180,
    pro_bono: false,
    linkedin_url: "https://linkedin.com/in/david-mwangi-saas",
    professional_website: "https://saasventures.africa",
    currency: "USD"
  },
  {
    email: "nomsa.zulu@nailab.mentors",
    full_name: "Nomsa Zulu",
    bio: "Marketing and growth expert. Scaled customer acquisition from 0 to 100K+ users across multiple African markets. Digital marketing specialist.",
    title: "Head of Growth, TechCabal",
    organization: "TechCabal",
    years_experience: 9,
    advisory_experience: 4,
    advisory_description: "Led growth for pan-African tech media company, grew audience from 50K to 500K+ across 10 countries.",
    sectors: ["media", "content", "marketing"],
    expertise: ["growth", "marketing", "user-acquisition"],
    stage_preference: ["mvp", "growth"],
    mentorship_approach: "Data-driven and creative, combining analytics with storytelling to drive user growth. Marketing is both an art and a science, and I help founders find the right balance for their product and market. My approach involves setting up proper analytics frameworks, A/B testing, and creative campaign strategies tailored to African markets. I believe in teaching founders how to fish rather than just giving them fish - I provide the methodologies and tools they need to become self-sufficient in their growth efforts. This includes building internal marketing capabilities and creating scalable growth systems that work across different African countries and cultures.",
    motivation: "Marketing is often overlooked in African startups - I want to change that narrative.",
    availability_hours_month: 15,
    preferred_mentorship_mode: "virtual",
    rate_per_hour: 100,
    pro_bono: true,
    linkedin_url: "https://linkedin.com/in/nomsa-zulu-growth",
    professional_website: "https://nomsazulu.com",
    currency: "USD"
  }
]

mentors_data.each do |mentor_data|
  user = seed_founder!(email: mentor_data[:email], full_name: mentor_data[:full_name])
  
  profile = UserProfile.find_or_initialize_by(user_id: user.id)
  profile.role = 'mentor'
  profile.onboarding_completed = true
  profile.profile_visibility = true
  
  # Remove email from mentor_data since it's not a profile field
  profile_data = mentor_data.except(:email)
  safe_assign(profile, profile_data)
  
  profile.save!
end

puts "✅ Seeded 4 mentors."

# Seed resources
puts "🌱 Seeding resources..."
resources_data = [
  # Blogs
  {
    title: "Building Scalable Startups in Africa: Lessons from Flutterwave",
    description: "Learn from Flutterwave's journey from a small payment processor to a $2B fintech giant. Key insights on team building, product-market fit, and navigating regulatory challenges in African markets.",
    content: "Flutterwave's story is a masterclass in African entrepreneurship...",
    resource_type: "blog",
    published_at: 2.weeks.ago,
    slug: "building-scalable-startups-africa-flutterwave",
    active: true
  },
  {
    title: "The Complete Guide to Raising Seed Capital in Africa",
    description: "Everything founders need to know about seed fundraising on the continent. From preparing your pitch deck to connecting with the right investors.",
    content: "Seed fundraising in Africa requires a different approach...",
    resource_type: "blog",
    published_at: 1.week.ago,
    slug: "complete-guide-seed-capital-africa",
    active: true
  },
  {
    title: "Healthcare Innovation: Solving Africa's Biggest Health Challenges",
    description: "Exploring how African startups are tackling healthcare access, telemedicine, and medical technology challenges with innovative solutions.",
    content: "Africa faces unique healthcare challenges...",
    resource_type: "blog",
    published_at: 3.days.ago,
    slug: "healthcare-innovation-africa-challenges",
    active: true
  },

  # Knowledge Hub - Templates and Guides
  {
    title: "Pitch Deck Template for African Startups",
    description: "A comprehensive pitch deck template designed specifically for African startups. Includes slides for market opportunity, competitive landscape, and financial projections.",
    content: "This template has been used by 200+ African startups to raise $50M+ in funding.",
    resource_type: "template",
    published_at: 1.month.ago,
    slug: "pitch-deck-template-african-startups",
    active: true
  },
  {
    title: "Financial Modeling Template for Early-Stage Startups",
    description: "Excel template for building 3-year financial projections. Includes revenue forecasting, burn rate calculations, and unit economics.",
    content: "Essential tool for any founder building their financial model.",
    resource_type: "template",
    published_at: 2.weeks.ago,
    slug: "financial-modeling-template-startups",
    active: true
  },
  {
    title: "Fundraising Checklist: From Seed to Series A",
    description: "Comprehensive checklist covering everything from investor outreach to term sheet negotiation. Never miss a step in your fundraising process.",
    content: "Based on successful fundraises by 50+ African startups.",
    resource_type: "template",
    published_at: 1.week.ago,
    slug: "fundraising-checklist-seed-series-a",
    active: true
  },

  # Opportunities
  {
    title: "Google for Startups Founders Funds - Africa 2025",
    description: "Apply for up to $150K in funding plus 6 months of mentorship and Google Cloud credits. Open to early-stage African startups.",
    content: "Application deadline: March 15, 2025. Focus areas: AI, Cloud, and Digital Transformation.",
    resource_type: "opportunity",
    published_at: 1.day.ago,
    slug: "google-startups-founders-funds-africa-2025",
    active: true
  },
  {
    title: "AfriLabs Accelerator Program - Spring 2025",
    description: "6-month accelerator program for East African startups. $25K equity investment plus workspace and mentorship.",
    content: "Applications open until February 28, 2025. Focus: Agtech, Fintech, Healthtech.",
    resource_type: "opportunity",
    published_at: 3.days.ago,
    slug: "afrilabs-accelerator-spring-2025",
    active: true
  },
  {
    title: "World Bank Innovation Challenge - Climate Tech",
    description: "Competitive grant program for African startups developing climate technology solutions. Up to $100K per winner.",
    content: "Submission deadline: April 30, 2025. Focus: Renewable energy, agriculture, water management.",
    resource_type: "opportunity",
    published_at: 1.week.ago,
    slug: "world-bank-innovation-challenge-climate-tech",
    active: true
  },

  # Events & Webinars
  {
    title: "Scaling Your African Startup: A Fireside Chat with Flutterwave Founders",
    description: "Join Iyinoluwa and Olugbenga Aboyeji for an intimate conversation about building and scaling Africa's largest fintech company.",
    content: "Date: January 15, 2025 | Time: 3:00 PM EAT | Platform: Zoom | Free registration required.",
    resource_type: "event",
    published_at: 2.days.ago,
    slug: "scaling-african-startup-fireside-chat-flutterwave",
    active: true
  },
  {
    title: "Webinar: Legal Essentials for African Startups",
    description: "Learn about company registration, intellectual property, contracts, and compliance requirements across African jurisdictions.",
    content: "Date: January 22, 2025 | Time: 2:00 PM EAT | Featuring: Leading African startup lawyers | Free for Nailab members.",
    resource_type: "event",
    published_at: 1.day.ago,
    slug: "webinar-legal-essentials-african-startups",
    active: true
  },
  {
    title: "Nailab Demo Day - Winter 2025 Cohort",
    description: "Watch 12 African startups pitch to a panel of top investors. Network with founders, investors, and fellow entrepreneurs.",
    content: "Date: February 5, 2025 | Time: 10:00 AM EAT | Location: Nairobi, Kenya | In-person & virtual attendance available.",
    resource_type: "event",
    published_at: 4.days.ago,
    slug: "nailab-demo-day-winter-2025-cohort",
    active: true
  }
]

resources_data.each do |resource_data|
  resource = Resource.find_or_initialize_by(slug: resource_data[:slug])
  resource.assign_attributes(resource_data)
  resource.save!
end

puts "✅ Seeded resources (blogs, templates, opportunities, events)."
