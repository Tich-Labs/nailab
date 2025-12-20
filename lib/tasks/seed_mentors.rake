namespace :db do
  desc "Seed mentor profiles with complete data"
  task seed_mentors: :environment do
    puts "Creating sample mentors with complete profiles..."

    # Sample mentor data based on the onboarding form
    mentors_data = [
      {
        email: "sarah.johnson@nailab.com",
        full_name: "Sarah Johnson",
        title: "Founder & CEO",
        bio: "Experienced entrepreneur with 8+ years in fintech and mobile payments. Founded two successful startups and advised 15+ early-stage companies. Passionate about helping African founders navigate the challenges of building scalable businesses.",
        organization: "PayFlow Technologies",
        years_experience: "6-10",
        advisory_experience: true,
        advisory_description: "Board member at 3 fintech startups, advised on fundraising rounds totaling $2M+",
        sectors: ["Fintech", "Mobiletech", "AI & ML"],
        expertise: ["Business model refinement", "Go-to-market planning and launch", "Pitching, fundraising, and investor readiness", "Product development"],
        stage_preference: ["Growth Stage", "Scaling Stage"],
        mentorship_approach: "I believe in hands-on mentorship that combines strategic guidance with practical tools. My approach focuses on helping founders identify their unique value proposition, build scalable business models, and prepare for successful fundraising rounds. I typically start with a deep-dive assessment of their current challenges and goals, then provide customized frameworks and resources.",
        motivation: "I'm passionate about empowering African entrepreneurs because I believe the continent has incredible potential for innovation. Having built my own companies here, I understand the unique challenges and opportunities. Every founder I mentor represents another step toward building a stronger African tech ecosystem.",
        availability_hours_month: 8, # 6-10 hours/month
        preferred_mentorship_mode: "Virtual",
        rate_per_hour: 150.00,
        pro_bono: false,
        currency: "USD",
        linkedin_url: "https://linkedin.com/in/sarah-johnson-mentor",
        professional_website: "https://sarahjohnson.mentor"
      },
      {
        email: "michael.chen@nailab.com",
        full_name: "Michael Chen",
        title: "Product Strategy Consultant",
        bio: "Product leader with 12+ years experience at Google, Microsoft, and African tech companies. Specialized in user-centered design, agile methodologies, and scaling products from MVP to millions of users. Former CTO of a Nairobi-based edtech startup.",
        organization: "Independent Consultant",
        years_experience: "10+",
        advisory_experience: true,
        advisory_description: "CTO at EdTech startup (scaled to 100K+ users), Product consultant for 20+ companies",
        sectors: ["Edutech", "SaaS", "Creative & Mediatech"],
        expertise: ["Product development", "Go-to-market planning and launch", "Marketing and branding", "Team building and HR"],
        stage_preference: ["Early Stage (MVP)", "Growth Stage"],
        mentorship_approach: "My mentorship style is collaborative and iterative. I work closely with founders to understand their vision, then help them build robust product strategies that align with market needs and business goals. I emphasize user research, data-driven decisions, and building products that people actually want to use.",
        motivation: "Technology has the power to solve Africa's biggest challenges, from education to healthcare to financial inclusion. I mentor because I want to help create products that make a real difference in people's lives while building sustainable businesses that create jobs and economic opportunity.",
        availability_hours_month: 12, # 10+ hours/month
        preferred_mentorship_mode: "Both",
        rate_per_hour: 200.00,
        pro_bono: false,
        currency: "USD",
        linkedin_url: "https://linkedin.com/in/michael-chen-product",
        professional_website: "https://michaelchen.consulting"
      },
      {
        email: "amina.diallo@nailab.com",
        full_name: "Amina Diallo",
        title: "Growth & Operations Director",
        bio: "Operations and growth expert with 7 years experience scaling B2B SaaS companies. Former Head of Growth at Flutterwave, where I helped expand from 50K to 2M+ monthly transactions. Deep expertise in customer acquisition, retention strategies, and operational excellence.",
        organization: "TechCabal",
        years_experience: "6-10",
        advisory_experience: true,
        advisory_description: "Growth consultant for 12 SaaS startups, board advisor for 2 fintech companies",
        sectors: ["Fintech", "SaaS", "E-commerce & Retailtech"],
        expertise: ["Go-to-market planning and launch", "Marketing and branding", "Sales and customer acquisition", "Budgeting and financial management"],
        stage_preference: ["Growth Stage", "Scaling Stage"],
        mentorship_approach: "I focus on helping founders build scalable growth engines. My approach combines strategic thinking with tactical execution - I help founders identify the most effective growth channels for their business, build efficient operations, and create sustainable customer acquisition strategies.",
        motivation: "African startups have unique opportunities to solve global problems with local insights. I mentor to help founders build businesses that not only succeed financially but also create positive impact in their communities and contribute to Africa's economic transformation.",
        availability_hours_month: 6, # 3-5 hours/month (pro bono)
        preferred_mentorship_mode: "Virtual",
        rate_per_hour: nil,
        pro_bono: true,
        currency: "USD",
        linkedin_url: "https://linkedin.com/in/amina-diallo-growth",
        professional_website: "https://aminadiallo.com"
      }
    ]

    mentors_data.each do |mentor_data|
      # Create user
      user = User.find_or_create_by!(email: mentor_data[:email]) do |u|
        u.password = "password123"
        u.password_confirmation = "password123"
        u.confirmed_at = Time.current
      end

      # Create or update user profile
      profile = user.user_profile || user.build_user_profile
      profile.assign_attributes(
        role: "mentor",
        full_name: mentor_data[:full_name],
        title: mentor_data[:title],
        bio: mentor_data[:bio],
        organization: mentor_data[:organization],
        years_experience: mentor_data[:years_experience],
        advisory_experience: mentor_data[:advisory_experience],
        advisory_description: mentor_data[:advisory_description],
        sectors: mentor_data[:sectors],
        expertise: mentor_data[:expertise],
        stage_preference: mentor_data[:stage_preference],
        mentorship_approach: mentor_data[:mentorship_approach],
        motivation: mentor_data[:motivation],
        availability_hours_month: mentor_data[:availability_hours_month],
        preferred_mentorship_mode: mentor_data[:preferred_mentorship_mode],
        rate_per_hour: mentor_data[:rate_per_hour],
        pro_bono: mentor_data[:pro_bono],
        currency: mentor_data[:currency],
        linkedin_url: mentor_data[:linkedin_url],
        professional_website: mentor_data[:professional_website],
        onboarding_completed: true,
        profile_visibility: true
      )
      profile.save!

      # Create mentor record if it doesn't exist
      unless user.mentor
        Mentor.create!(user: user)
      end

      puts "Created mentor: #{mentor_data[:full_name]}"
    end

    puts "Seeded #{mentors_data.count} mentors with complete profiles!"
  end
end