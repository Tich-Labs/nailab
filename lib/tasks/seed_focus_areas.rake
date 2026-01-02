namespace :db do
  namespace :seed do
    desc "Seed frontend Focus Area cards only"
    task focus_areas: :environment do
      unless defined?(FocusArea)
        puts "FocusArea model not defined — skipping"
        next
      end

      frontend_focus_areas = [
        { title: "HealthTech", description: "Innovative solutions improving healthcare accessibility and quality across Africa", icon: "health", display_order: 1 },
        { title: "AgriTech", description: "Technologies enhancing agricultural productivity and sustainability.", icon: "agriculture", display_order: 2 },
        { title: "FinTech", description: "Innovations making banking, payments, and financial services more accessible.", icon: "fintech", display_order: 3 },
        { title: "EduTech", description: "Digital solutions revolutionizing education and skill development in Africa.", icon: "education", display_order: 4 },
        { title: "CleanTech", description: "Sustainable solutions for renewable energy and environmental conservation.", icon: "cleantech", display_order: 5 },
        { title: "E-commerce & RetailTech", description: "Innovative solutions transforming how Africans shop and access goods, no matter where they live.", icon: "ecommerce", display_order: 6 },
        { title: "SaaS", description: "Empowering businesses with scalable software solutions to enhance operations and growth.", icon: "saas", display_order: 7 },
        { title: "AI & ML", description: "Artificial intelligence and machine learning applications solving African challenges.", icon: "ai", display_order: 8 },
        { title: "Robotics", description: "Robotic innovations addressing industrial and social needs across the continent.", icon: "robotics", display_order: 9 },
        { title: "MobileTech", description: "Mobile-first solutions designed for Africa's rapidly growing smartphone market.", icon: "mobile", display_order: 10 },
        { title: "Mobility & LogisticsTech", description: "Streamlining the movement of people and goods for a more connected Africa.", icon: "mobility", display_order: 11 },
        { title: "Creative & MediaTech", description: "Revolutionizing digital content creation and consumption across the continent.", icon: "creative", display_order: 12 }
      ]

      frontend_focus_areas.each do |data|
        fa = FocusArea.find_or_initialize_by(title: data[:title])
        fa.assign_attributes(data.merge(active: true))
        fa.save!
      end

      puts "Seeded #{frontend_focus_areas.size} focus areas."
    end
  end
end
