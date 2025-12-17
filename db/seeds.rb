# frozen_string_literal: true

SEED_USER_PASSWORD = ENV.fetch('SEED_USER_PASSWORD', 'Nailab123!')

HERO_SLIDES = [
	}
].freeze

HOME_PAGE_CONTENT = {
	hero: {
		badge: 'Startup growth, made in Africa',
		slides: [
			{
				title: 'Scale faster with Nairobi’s most active mentor network',
				subtitle: 'Apply to tailored programs, unlock funding readiness clinics, and get matched with mentors who understand Africa.',
				image_url: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80',
				cta_text: 'Explore Programs',
				cta_link: '/programs'
			},
			{
				title: "Mentorship designed for Africa’s founders",
				subtitle: 'Personalized guidance on fundraising, product-market fit, and go-to-market plans from mentors who have scaled across the continent.',
				image_url: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=1600&q=80',
				cta_text: 'Meet Mentors',
				cta_link: '/mentors'
			},
			{
				title: 'Resources, capital, and community in one place',
				subtitle: 'Templates, playbooks, and investor-ready tools to help you launch, iterate, and scale.',
				image_url: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=1600&q=80',
				cta_text: 'Browse Resources',
				cta_link: '/resources'
			}
		],
		secondary_cta: { label: 'Find a Mentor', link: '/mentors' }
	},
	who_we_are: {
		title: 'Who We Are',
		subheading: 'Empowering African founders with hands-on coaching, capital, and community.',
		paragraph_one: 'Nailab is a founder-first incubator and accelerator, founded in 2010, dedicated to supporting early-stage and growth-stage startups with mentorship, capital, and the networks they need to solve Africa’s hardest problems.',
		paragraph_two: 'Through tailored acceleration programs, practical workshops, and investor connections, we have helped founders across the continent build scalable, impact-driven businesses.',
		cta_label: 'More About Us',
		cta_link: '/about',
		image_url: 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=1200'
	},
	how_we_support: [
		{
			title: 'Create your founder profile',
			description: 'Set up your profile to track progress, surface opportunities, and pair with the right mentors and programs.',
			cta_label: 'Set up profile',
			cta_link: '/signup'
		},
		{
			title: 'Find mentors',
			description: 'Book 1-on-1 mentorship sessions with seasoned operators who can help you refine strategy, operations, product, and leadership.',
			cta_label: 'Book mentorship',
			cta_link: '/mentors'
		},
		{
			title: 'Peer-to-peer network',
			description: 'Connect with fellow founders, share insights, and build supportive relationships across the continent.',
			cta_label: 'Join the community',
			cta_link: '/startups'
		},
		{
			title: 'Access growth resources',
			description: 'Browse curated templates, playbooks, funding leads, and invites to pitch days and accelerator opportunities.',
			cta_label: 'Explore resources',
			cta_link: '/resources'
		}
	],
	connect_grow_impact: {
		intro: 'Join a thriving community of African founders, mentors, and partners. Share knowledge, access opportunities, and drive innovation together.',
		stats: [
			{ value: '1000+', label: 'Startups supported' },
			{ value: '50+', label: 'Partners' },
			{ value: '$100M', label: 'Funding facilitated' }
		],
		cards: [
			{
				title: 'For Founders',
				description: 'Gain access to mentors, cohorts, and curated resources that help you launch, grow, and scale across Africa.',
				cta_label: 'Start your journey with us',
				cta_link: '/programs'
			},
			{
				title: 'For Mentors',
				description: 'Guide promising founders, share lessons from your journey, and play a role in shaping the next wave of African innovation.',
				cta_label: 'Become a Mentor',
				cta_link: '/mentors'
			},
			{
				title: 'For Partners',
				description: 'Collaborate with Nailab to co-create programs, support startups, and drive inclusive innovation alongside corporates and institutions.',
				cta_label: 'Partner with us',
				cta_link: '/partners'
			}
		]
	},
	bottom_cta: {
		heading: 'Ready to grow your startup?',
		body: 'Join Nailab and connect with mentors, programs, and a thriving community of innovators.',
		primary_cta: { label: 'Browse Programs', link: '/programs' },
		secondary_cta: { label: 'Find a Mentor', link: '/mentors' }
	}
}.freeze

home_page = StaticPage.find_or_initialize_by(slug: 'home')
home_page.title = 'Home'
home_page.content = home_page.content.presence || ''
home_page.structured_content = HOME_PAGE_CONTENT
home_page.save!
].freeze

PARTNERS = [
	{
		name: 'Nairobi Innovation Week',
		logo_url: 'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?auto=format&fit=crop&w=800&q=80',
		website_url: 'https://nairobinnovationweek.ke',
		display_order: 1,
		active: true
	},
	{
		name: 'Africa Fintech Lab',
		logo_url: 'https://images.unsplash.com/photo-1520607162513-77705c0f0d4a?auto=format&fit=crop&w=800&q=80',
		website_url: 'https://africafintechlab.org',
		display_order: 2,
		active: true
	},
	{
		name: 'MIT Regional Entrepreneurship Program',
		logo_url: 'https://images.unsplash.com/photo-1529333166437-7750a6dd5a70?auto=format&fit=crop&w=800&q=80',
		website_url: 'https://mit.edu',
		display_order: 3,
		active: true
	},
	{
		name: 'Google for Startups Africa',
		logo_url: 'https://images.unsplash.com/photo-1520607162513-77705c0f0d4a?auto=format&fit=crop&w=800&q=80',
		website_url: 'https://startup.google.com',
		display_order: 4,
		active: true
	}
].freeze

TESTIMONIALS = [
	{
		author_name: 'Fatima Odhiambo',
		author_role: 'Founder, AgroNova',
		organization: 'AgroNova',
		quote: 'Nailab matched me with mentors who understood my market, pointed out weaknesses in our pitch, and introduced me to customers in two countries.',
		photo_url: 'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=800&q=80',
		rating: 5,
		display_order: 1,
		active: true
	},
	{
		author_name: 'Omar Amari',
		author_role: 'CEO, SokoLink',
		organization: 'SokoLink',
		quote: 'The hands-on workshops and regular mentor check-ins helped us secure a pilot with a Lagos-based retailer in under 60 days.',
		photo_url: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
		rating: 5,
		display_order: 2,
		active: true
	},
	{
		author_name: 'Zara Mensah',
		author_role: 'COO, BrightLearn',
		organization: 'BrightLearn',
		quote: 'Nailab is my go-to for operational checklists, fundraising templates, and real mentors who actually hold me accountable.',
		photo_url: 'https://images.unsplash.com/photo-1504593811423-6dd665756598?auto=format&fit=crop&w=800&q=80',
		rating: 5,
		display_order: 3,
		active: true
	}
].freeze

PROGRAMS = [
	{
		title: 'Nailab Growth Accelerator',
		slug: 'nailab-growth-accelerator',
		description: 'Intensive 12-week program for revenue-generating startups ready to expand across Africa.',
		content: 'Curriculum covers fundraising, product-market fit, GTM strategy, and team building with weekly mentor office hours.',
		cover_image_url: 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?auto=format&fit=crop&w=1600&q=80',
		category: 'accelerator',
		start_date: Date.new(2026, 2, 1),
		end_date: Date.new(2026, 4, 30),
		active: true
	},
	{
		title: 'Nailab Founder Fellowship',
		slug: 'nailab-founder-fellowship',
		description: 'Selective cohort for early-stage founders looking for cohort-based learning and investor intros.',
		content: 'Includes equity-free funding, curated mentor office hours, and investor-day preparation.',
		cover_image_url: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1600&q=80',
		category: 'fellowship',
		start_date: Date.new(2026, 5, 5),
		end_date: Date.new(2026, 7, 15),
		active: true
	},
	{
		title: 'Nailab Global Expansion Lab',
		slug: 'nailab-global-expansion-lab',
		description: 'Designed for later-stage African startups launching into Europe or North America.',
		content: 'Works across legal, compliance, and GTM channels, combining mentors in-market with investor partners.',
		cover_image_url: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1600&q=80',
		category: 'lab',
		start_date: Date.new(2026, 9, 1),
		end_date: Date.new(2026, 11, 30),
		active: true
	}
].freeze

FOCUS_AREAS = [
	{ title: 'Mentorship', description: 'One-on-one partner mentors, roundtable office hours, and accountability cohorts.', icon: 'users', display_order: 1 },
	{ title: 'Capital Access', description: 'Prepare for investor meetings, access grant networks, and raise with confidence.', icon: 'dollar-sign', display_order: 2 },
	{ title: 'Community & Events', description: 'Peer cohorts, founder salons, and introductions to African ecosystem partners.', icon: 'sparkles', display_order: 3 }
].freeze

RESOURCES = [
	{ title: 'Building a Winning Pitch Deck for African Investors', description: 'African investors look beyond traction—they prioritize impact, team resilience, and market understanding. Learn the 10 slides every founder needs and common mistakes that kill deals in Kenya, Nigeria, and South Africa.', resource_type: 'blog', published_at: Date.new(2025, 11, 15), url: 'https://nailab.app/blog/african-investor-pitch-deck', active: true },
	{ title: 'How AgriTech Startups Can Achieve Product-Market Fit in Rural Africa', description: 'From soil sensors to market linkages, many AgriTech solutions fail because they solve the wrong problem. This guide walks through customer discovery frameworks proven in East African farming communities.', resource_type: 'blog', published_at: Date.new(2025, 10, 28), url: 'https://nailab.app/blog/agritech-pmf', active: true },
	{ title: 'Navigating Regulatory Challenges in African FinTech', description: 'Central banks across Africa are tightening rules on digital lending, payments, and crypto. Here’s what founders need to know about compliance in Kenya, Nigeria, Ghana, and Rwanda in 2025–2026.', resource_type: 'blog', published_at: Date.new(2025, 10, 10), url: 'https://nailab.app/blog/fintech-regulation', active: true },
	{ title: 'Scaling HealthTech Solutions Across Language and Infrastructure Barriers', description: 'From USSD-based diagnostics to AI translation tools, discover how top HealthTech startups are reaching last-mile patients in multilingual, low-connectivity regions.', resource_type: 'blog', published_at: Date.new(2025, 9, 22), url: 'https://nailab.app/blog/healthtech-scaling', active: true },
	{ title: 'Why Most African EdTech Startups Fail to Retain Users — And How to Fix It', description: 'Retention rates below 10% are common in African EdTech. This post breaks down behavioral design principles and offline-first strategies that boosted one startup’s retention to 45%.', resource_type: 'blog', published_at: Date.new(2025, 8, 30), url: 'https://nailab.app/blog/edtech-retention', active: true },
	{ title: 'Pitch Deck Template (PowerPoint/Google Slides)', description: 'A 12-slide template used by Nailab alumni who raised over $10M collectively. Includes investor-tested structure, financial model tips, and design guidelines.', resource_type: 'template', published_at: Date.new(2025, 11, 1), url: 'https://nailab.app/resources/pitch-deck-template', active: true },
	{ title: 'Fundraising Checklist for African Founders', description: 'Step-by-step checklist covering pre-seed to Series A: cap table setup, due diligence prep, term sheet basics, and investor outreach tracker.', resource_type: 'template', published_at: Date.new(2025, 10, 5), url: 'https://nailab.app/resources/fundraising-checklist', active: true },
	{ title: 'Customer Discovery Interview Script Pack', description: '50+ tailored questions for AgriTech, HealthTech, FinTech, and EduTech founders. Includes follow-up probes and bias-reduction tips.', resource_type: 'template', published_at: Date.new(2025, 9, 14), url: 'https://nailab.app/resources/discovery-script-pack', active: true },
	{ title: 'Financial Model Template for Early-Stage Startups', description: '3-statement model (P&L, Cash Flow, Balance Sheet) with Africa-specific assumptions (M-Pesa fees, currency volatility, grant revenue).', resource_type: 'template', published_at: Date.new(2025, 8, 20), url: 'https://nailab.app/resources/finance-model', active: true },
	{ title: 'Go-to-Market Strategy Canvas', description: 'One-page framework to map channels, messaging, partnerships, and pricing — used in Nailab acceleration programs.', resource_type: 'template', published_at: Date.new(2025, 7, 15), url: 'https://nailab.app/resources/gtm-canvas', active: true },
	{ title: 'Nailab Acceleration Program Cohort 2026', description: 'Deadline Jan 31, 2026 — equity-free funding up to $15,000, 6-month mentorship, and investor demo day for early-stage tech startups in HealthTech, AgriTech, FinTech, and EduTech.', resource_type: 'opportunity', published_at: Date.new(2025, 12, 1), url: 'https://nailab.app/opportunities/2026-acceleration', active: true },
	{ title: 'Africa Climate Tech Innovation Grant', description: 'UNFPA & partners offer $5,000–$20,000 grants for climate-resilient SRHR and youth-led solutions. Deadline Feb 15, 2026.', resource_type: 'opportunity', published_at: Date.new(2025, 11, 25), url: 'https://nailab.app/opportunities/climate-grant', active: true },
	{ title: 'KCB Foundation 2Jiajiri Youth Challenge', description: 'Mentorship, incubation, and up to KES 1M grant for youth entrepreneurs across Kenya. Deadline Mar 10, 2026.', resource_type: 'opportunity', published_at: Date.new(2025, 11, 10), url: 'https://nailab.app/opportunities/2jiajiri', active: true },
	{ title: 'Jack Ma Foundation Africa Netpreneur Prize 2026', description: 'Prize pool of $1M for top 10 finalists—African entrepreneurs across sectors. Deadline Apr 30, 2026.', resource_type: 'opportunity', published_at: Date.new(2025, 10, 18), url: 'https://nailab.app/opportunities/netpreneur', active: true },
	{ title: 'GIZ Make-IT Africa Accelerator', description: '9-month program with corporate partnerships and investment readiness support in Kenya, Rwanda, Uganda, and Mozambique. Deadline Dec 31, 2025.', resource_type: 'opportunity', published_at: Date.new(2025, 9, 1), url: 'https://nailab.app/opportunities/make-it', active: true },
	{ title: 'Webinar: Raising Capital in 2026 — What African VCs Want', description: 'Jan 20, 2026 | 4:00 PM EAT. Virtual session with TLCom Capital and Novastar Ventures partners. Registration open.', resource_type: 'event', published_at: Date.new(2026, 1, 20), url: 'https://nailab.app/events/raising-capital-2026', active: true },
	{ title: 'Nairobi Startup Week 2026', description: 'Feb 10–14, 2026. Hybrid flagship event with pitch competitions, investor office hours, and workshops hosted by Nailab & partners.', resource_type: 'event', published_at: Date.new(2026, 2, 10), url: 'https://nailab.app/events/startup-week-2026', active: true },
	{ title: 'Women in AgriTech Panel (Recording)', description: 'Oct 5, 2025. Replay featuring founders from Kenya, Nigeria, and Uganda discussing inclusive AgriTech.', resource_type: 'event', published_at: Date.new(2025, 10, 5), url: 'https://nailab.app/events/women-agritech', active: true },
	{ title: 'FinTech Regulatory Masterclass', description: 'Dec 18, 2025 | 11:00 AM EAT. Central Bank of Kenya speaker walks through digital lending and payments policy updates.', resource_type: 'event', published_at: Date.new(2025, 12, 18), url: 'https://nailab.app/events/fintech-regulation', active: true },
	{ title: 'HealthTech Demo Day 2025 (Recording)', description: 'Sept 25, 2025. 10 startups pitched to investors, 3 secured term sheets. Recording and pitch decks available.', resource_type: 'event', published_at: Date.new(2025, 9, 25), url: 'https://nailab.app/events/healthtech-demo-day', active: true }
].freeze

MENTORS = [
	{
		email: 'amina.odhiambo@seed.nailab.app',
		full_name: 'Amina Odhiambo',
		bio: 'Seasoned fintech entrepreneur with 12 years building payment solutions across East Africa. Successfully scaled two startups and exited one to a major telecom. Passionate about financial inclusion.',
		title: 'Founder & CEO',
		organization: 'Pesa Tech Solutions',
		location: 'Nairobi, Kenya',
		linkedin_url: 'https://linkedin.com/in/aminaodhiambo',
		years_experience: 12,
		advisory_experience: true,
		sectors: ['Fintech', 'Mobiletech', 'SaaS'],
		expertise: ['Pitching, fundraising, and investor readiness', 'Product-market fit', 'Go-to-market planning and launch', 'Market expansion (local or regional)'],
		stage_preference: ['mvp', 'growth', 'scale'],
		availability_hours_month: 10,
		rate_per_hour: 150.0,
		pro_bono: false,
		preferred_mentorship_mode: 'both',
		profile_visibility: true,
		onboarding_completed: true
	},
	{
		email: 'chukwudi.eze@seed.nailab.app',
		full_name: 'Chukwudi Eze',
		bio: "Agricultural economist turned entrepreneur. Built Nigeria's largest farm-to-market platform. Expert in agricultural value chains, logistics, and scaling operations across West Africa.",
		title: 'Co-founder & Chief Strategy Officer',
		organization: 'FarmConnect Africa',
		location: 'Lagos, Nigeria',
		linkedin_url: 'https://linkedin.com/in/chukwudieze',
		years_experience: 15,
		advisory_experience: true,
		sectors: ['Agritech', 'Mobility & Logisticstech', 'E-commerce & Retailtech'],
		expertise: ['Business model refinement', 'Access to customers and markets', 'Strategic partnerships and collaborations', 'Budgeting and financial management'],
		stage_preference: ['idea', 'mvp', 'growth'],
		availability_hours_month: 8,
		rate_per_hour: 0.0,
		pro_bono: true,
		preferred_mentorship_mode: 'virtual',
		profile_visibility: true,
		onboarding_completed: true
	},
	{
		email: 'thandiwe.nkosi@seed.nailab.app',
		full_name: 'Thandiwe Nkosi',
		bio: 'Medical doctor and health tech innovator with deep experience in telemedicine and health insurance tech. Raised Series B funding and built teams across 5 African countries.',
		title: 'CEO & Founder',
		organization: 'HealthBridge Africa',
		location: 'Cape Town, South Africa',
		linkedin_url: 'https://linkedin.com/in/thandiwenkosi',
		years_experience: 10,
		advisory_experience: true,
		sectors: ['Healthtech', 'SaaS', 'AI & ML'],
		expertise: ['Pitching, fundraising, and investor readiness', 'Team building and HR', 'Product development', 'Legal or regulatory guidance'],
		stage_preference: ['mvp', 'growth', 'scale'],
		availability_hours_month: 12,
		rate_per_hour: 200.0,
		pro_bono: false,
		preferred_mentorship_mode: 'both',
		profile_visibility: true,
		onboarding_completed: true
	},
	{
		email: 'kwame.asante@seed.nailab.app',
		full_name: 'Kwame Asante',
		bio: "Former teacher turned edtech entrepreneur. Built Ghana's leading online learning platform serving 500K+ students. Angel investor in 8 African startups.",
		title: 'Managing Partner',
		organization: 'Learn Africa Ventures',
		location: 'Accra, Ghana',
		linkedin_url: 'https://linkedin.com/in/kwameasante',
		years_experience: 8,
		advisory_experience: true,
		sectors: ['Edutech', 'SaaS', 'Creative & Mediatech'],
		expertise: ['Product-market fit', 'Sales and customer acquisition', 'Marketing and branding', 'Leadership and personal growth'],
		stage_preference: ['idea', 'mvp', 'growth'],
		availability_hours_month: 6,
		rate_per_hour: 100.0,
		pro_bono: false,
		preferred_mentorship_mode: 'virtual',
		profile_visibility: true,
		onboarding_completed: true
	},
	{
		email: 'grace.uwase@seed.nailab.app',
		full_name: 'Grace Uwase',
		bio: 'Software engineer and serial entrepreneur. Built and sold a SaaS company. Now angel investor and advocate for women in tech. Expertise in B2B SaaS and enterprise sales.',
		title: 'Founder',
		organization: 'TechHer Africa',
		location: 'Kigali, Rwanda',
		linkedin_url: 'https://linkedin.com/in/graceuwase',
		years_experience: 9,
		advisory_experience: true,
		sectors: ['SaaS', 'Fintech', 'E-commerce & Retailtech'],
		expertise: ['Product development', 'Go-to-market planning and launch', 'Sales and customer acquisition', 'Team building and HR'],
		stage_preference: ['idea', 'mvp', 'growth'],
		availability_hours_month: 10,
		rate_per_hour: 0.0,
		pro_bono: true,
		preferred_mentorship_mode: 'both',
		profile_visibility: true,
		onboarding_completed: true
	},
	{
		email: 'omar.hassan@seed.nailab.app',
		full_name: 'Omar Hassan',
		bio: 'E-commerce pioneer with 14 years experience building online marketplaces in MENA region. Scaled operations to 8 countries. Expert in logistics, payments, and cross-border commerce.',
		title: 'Chief Commercial Officer',
		organization: 'Souq Africa',
		location: 'Cairo, Egypt',
		linkedin_url: 'https://linkedin.com/in/omarhassan',
		years_experience: 14,
		advisory_experience: true,
		sectors: ['E-commerce & Retailtech', 'Mobility & Logisticstech', 'Fintech'],
		expertise: ['Market expansion (local or regional)', 'Strategic partnerships and collaborations', 'Budgeting and financial management', 'Access to customers and markets'],
		stage_preference: ['growth', 'scale'],
		availability_hours_month: 8,
		rate_per_hour: 180.0,
		pro_bono: false,
		preferred_mentorship_mode: 'virtual',
		profile_visibility: true,
		onboarding_completed: true
	},
	{
		email: 'sarah.nansubuga@seed.nailab.app',
		full_name: 'Sarah Nansubuga',
		bio: 'Mobile-first product leader with expertise in building for emerging markets. Led product at major African tech company. Deep understanding of mobile money, USSD, and low-bandwidth solutions.',
		title: 'VP of Product',
		organization: 'Mobile Innovations Ltd',
		location: 'Kampala, Uganda',
		linkedin_url: 'https://linkedin.com/in/sarahnansubuga',
		years_experience: 7,
		advisory_experience: true,
		sectors: ['Mobiletech', 'Fintech', 'SaaS'],
		expertise: ['Product-market fit', 'Product development', 'Go-to-market planning and launch', 'Access to customers and markets'],
		stage_preference: ['idea', 'mvp', 'growth'],
		availability_hours_month: 6,
		rate_per_hour: 120.0,
		pro_bono: false,
		preferred_mentorship_mode: 'both',
		profile_visibility: true,
		onboarding_completed: true
	},
	{
		email: 'mamadou.diop@seed.nailab.app',
		full_name: 'Mamadou Diop',
		bio: 'Clean energy entrepreneur and impact investor. Built solar energy company serving 100K+ households. Now investing in climate tech across francophone Africa.',
		title: 'Managing Director',
		organization: 'Green Future Capital',
		location: 'Dakar, Senegal',
		linkedin_url: 'https://linkedin.com/in/mamadoudiop',
		years_experience: 11,
		advisory_experience: true,
		sectors: ['Cleantech', 'Agritech', 'SaaS'],
		expertise: ['Pitching, fundraising, and investor readiness', 'Business model refinement', 'Strategic partnerships and collaborations', 'Leadership and personal growth'],
		stage_preference: ['mvp', 'growth', 'scale'],
		availability_hours_month: 10,
		rate_per_hour: 0.0,
		pro_bono: true,
		preferred_mentorship_mode: 'both',
		profile_visibility: true,
		onboarding_completed: true
	}
].freeze

FOUNDERS = [
	{
		email: 'james.mwangi@seed.nailab.app',
		full_name: 'James Mwangi',
		bio: 'Agricultural engineer passionate about using technology to connect smallholder farmers to markets. Building a platform to revolutionize agricultural supply chains.',
		role: 'founder',
		location: 'Nakuru, Kenya',
		sectors: ['Agritech'],
		preferred_mentorship_mode: 'virtual',
		phone_number: '+254722123456',
		startup: {
			startup_name: 'FarmLink Kenya',
			description: 'Digital platform connecting smallholder farmers directly to buyers, eliminating middlemen and ensuring fair prices. Provides market information, logistics support, and mobile payment integration.',
			sector: 'Agritech',
			stage: 'mvp',
			location: 'Nakuru, Kenya',
			target_market: 'Smallholder farmers (25-60 years) in Central and Rift Valley regions, urban retailers and restaurants.',
			value_proposition: 'Eliminates 3-4 layers of middlemen, increasing farmer income by 40% while reducing costs for buyers by 25%. Mobile-first platform works offline and integrates with M-Pesa.',
			funding_stage: 'pre_seed',
			funding_raised: 50_000,
			mentorship_areas: ['Access to customers and markets', 'Pitching, fundraising, and investor readiness', 'Product-market fit'],
			challenge_details: 'Need help acquiring first 500 farmers and 50 buyer accounts. Also preparing for seed round and refining unit economics.',
			preferred_mentorship_mode: 'virtual',
			phone_number: '+254722123456',
			target_team_size: 12,
			founded_year: 2023
		}
	},
	{
		email: 'ngozi.okafor@seed.nailab.app',
		full_name: 'Ngozi Okafor',
		bio: 'Medical lab scientist building AI-powered diagnostic tools for resource-limited settings. Determined to make quality healthcare accessible across Nigeria.',
		role: 'founder',
		location: 'Abuja, Nigeria',
		sectors: ['Healthtech', 'AI & ML'],
		preferred_mentorship_mode: 'both',
		phone_number: '+234803456789',
		startup: {
			startup_name: 'DiagnoAI',
			description: 'AI-powered diagnostic platform that analyzes medical images and lab results to assist healthcare workers in resource-limited settings.',
			sector: 'Healthtech',
			stage: 'mvp',
			location: 'Abuja, Nigeria',
			target_market: 'Primary healthcare centers, general hospitals, diagnostic labs; telemedicine platforms.',
			value_proposition: '94% accuracy in detecting common diseases, matching specialist-level diagnosis at 1/10th the cost. Works offline with minimal training.',
			funding_stage: 'seed',
			funding_raised: 180_000,
			mentorship_areas: ['Legal or regulatory guidance', 'Product development', 'Strategic partnerships and collaborations'],
			challenge_details: 'Navigating medical device regulations and certifications, partnering with hospital networks, and scaling the AI model.',
			preferred_mentorship_mode: 'both',
			phone_number: '+234803456789',
			target_team_size: 18,
			founded_year: 2022
		}
	},
	{
		email: 'lerato.mokoena@seed.nailab.app',
		full_name: 'Lerato Mokoena',
		bio: 'Former banker building a digital lending platform for SMEs in townships. Passionate about financial inclusion and empowering underserved communities.',
		role: 'founder',
		location: 'Johannesburg, South Africa',
		sectors: ['Fintech'],
		preferred_mentorship_mode: 'in_person',
		phone_number: '+27823456789',
		startup: {
			startup_name: 'Township Capital',
			description: 'Digital lending platform providing working capital loans to informal sector SMEs in South African townships.',
			sector: 'Fintech',
			stage: 'growth',
			location: 'Johannesburg, South Africa',
			target_market: 'Informal sector entrepreneurs (30-55) running spaza shops, salons, mechanics, and catering businesses.',
			value_proposition: 'Alternative credit scoring based on mobile money, utility payments, and location data. 72-hour approval, 95% digital process.',
			funding_stage: 'seed',
			funding_raised: 350_000,
			mentorship_areas: ['Budgeting and financial management', 'Market expansion (local or regional)', 'Team building and HR'],
			challenge_details: 'Managing rapid growth while maintaining loan quality, expanding provinces, and improving credit risk models.',
			preferred_mentorship_mode: 'in_person',
			phone_number: '+27823456789',
			target_team_size: 25,
			founded_year: 2021
		}
	},
	{
		email: 'ama.osei@seed.nailab.app',
		full_name: 'Ama Osei',
		bio: 'Educator and software developer creating adaptive learning platforms for African students. Focused on STEM education and bridging the digital divide.',
		role: 'founder',
		location: 'Kumasi, Ghana',
		sectors: ['Edutech'],
		preferred_mentorship_mode: 'virtual',
		phone_number: '+233244123456',
		startup: {
			startup_name: 'BrainBoost Africa',
			description: 'Adaptive learning platform for STEM subjects, personalizing content based on student performance.',
			sector: 'Edutech',
			stage: 'mvp',
			location: 'Kumasi, Ghana',
			target_market: 'Junior and senior high students (12-18) across Ghana, especially peri-urban and rural areas with limited access to quality STEM teachers.',
			value_proposition: 'Adaptive engine identifies knowledge gaps and personalizes learning paths, improving scores by 35%. Gamified lessons work offline and are 80% cheaper.',
			funding_stage: 'bootstrapped',
			funding_raised: 25_000,
			mentorship_areas: ['Product-market fit', 'Sales and customer acquisition', 'Go-to-market planning and launch'],
			challenge_details: 'Struggling with B2C customer acquisition; exploring B2B with schools and pricing strategy.',
			preferred_mentorship_mode: 'virtual',
			phone_number: '+233244123456',
			target_team_size: 14,
			founded_year: 2022
		}
	},
	{
		email: 'eric.habimana@seed.nailab.app',
		full_name: 'Eric Habimana',
		bio: 'Serial entrepreneur building a B2B e-commerce platform connecting manufacturers with retailers across East Africa. Passionate about trade and economic integration.',
		role: 'founder',
		location: 'Kigali, Rwanda',
		sectors: ['E-commerce & Retailtech'],
		preferred_mentorship_mode: 'both',
		phone_number: '+250788123456',
		startup: {
			startup_name: 'TradeHub East Africa',
			description: 'B2B e-commerce and logistics platform simplifying cross-border trade and last-mile delivery.',
			sector: 'E-commerce & Retailtech',
			stage: 'growth',
			location: 'Kigali, Rwanda',
			target_market: 'SME retailers across Rwanda, Kenya, Uganda, Tanzania plus manufacturers seeking regional distribution.',
			value_proposition: 'Single platform for product discovery, ordering, payments, customs clearance, and delivery, cutting procurement costs by 30% and delivery time by 50%.',
			funding_stage: 'series_a',
			funding_raised: 1_200_000,
			mentorship_areas: ['Market expansion (local or regional)', 'Strategic partnerships and collaborations', 'Team building and HR'],
			challenge_details: 'Scaling operations across 4 countries with different regs, managing working capital, and forming logistics partnerships.',
			preferred_mentorship_mode: 'both',
			phone_number: '+250788123456',
			target_team_size: 40,
			founded_year: 2020
		}
	},
	{
		email: 'fatuma.ally@seed.nailab.app',
		full_name: 'Fatuma Ally',
		bio: 'Transportation logistics expert building smart routing solutions for last-mile delivery in African cities. Focused on reducing costs and improving efficiency.',
		role: 'founder',
		location: 'Dar es Salaam, Tanzania',
		sectors: ['Mobility & Logisticstech'],
		preferred_mentorship_mode: 'virtual',
		phone_number: '+255754123456',
		startup: {
			startup_name: 'SwiftRoute',
			description: 'AI-powered routing and fleet management platform optimizing last-mile delivery.',
			sector: 'Mobility & Logisticstech',
			stage: 'mvp',
			location: 'Dar es Salaam, Tanzania',
			target_market: 'Logistics companies, e-commerce platforms, retailers operating in East African cities.',
			value_proposition: 'AI considers traffic, road conditions, delivery windows, and vehicle capacity to reduce fuel costs by 25% and increase deliveries by 40%.',
			funding_stage: 'pre_seed',
			funding_raised: 75_000,
			mentorship_areas: ['Product development', 'Access to customers and markets', 'Pitching, fundraising, and investor readiness'],
			challenge_details: 'Need more local data to improve AI, enterprise customer acquisition, and preparation for seed round.',
			preferred_mentorship_mode: 'virtual',
			phone_number: '+255754123456',
			target_team_size: 20,
			founded_year: 2023
		}
	},
	{
		email: 'dawit.tekle@seed.nailab.app',
		full_name: 'Dawit Tekle',
		bio: 'Environmental engineer developing affordable biogas solutions for rural households. Committed to clean energy access and reducing deforestation.',
		role: 'founder',
		location: 'Addis Ababa, Ethiopia',
		sectors: ['Cleantech'],
		preferred_mentorship_mode: 'virtual',
		phone_number: '+251911123456',
		startup: {
			startup_name: 'BioEnergy Ethiopia',
			description: 'Affordable biogas systems converting waste into clean cooking fuel.',
			sector: 'Cleantech',
			stage: 'growth',
			location: 'Addis Ababa, Ethiopia',
			target_market: 'Rural households using firewood/charcoal and small-scale farmers seeking organic fertilizer.',
			value_proposition: 'Modular biogas systems cost 60% less than competitors, pay for themselves in 2 years, improve indoor air quality, and produce organic fertilizer.',
			funding_stage: 'seed',
			funding_raised: 280_000,
			mentorship_areas: ['Business model refinement', 'Strategic partnerships and collaborations', 'Budgeting and financial management'],
			challenge_details: 'Exploring pay-as-you-go financing, partnerships with NGOs/government, and managing cash flow while scaling manufacturing.',
			preferred_mentorship_mode: 'virtual',
			phone_number: '+251911123456',
			target_team_size: 15,
			founded_year: 2021
		}
	},
	{
		email: 'mwila.banda@seed.nailab.app',
		full_name: 'Mwila Banda',
		bio: 'Software engineer building cloud-based accounting tools for African SMEs. Focused on simplifying business management for non-technical entrepreneurs.',
		role: 'founder',
		location: 'Lusaka, Zambia',
		sectors: ['SaaS'],
		preferred_mentorship_mode: 'both',
		phone_number: '+260977123456',
		startup: {
			startup_name: 'CountRight',
			description: 'Cloud-based accounting and business management software designed for African SMEs, mobile-first and offline-ready.',
			sector: 'SaaS',
			stage: 'mvp',
			location: 'Lusaka, Zambia',
			target_market: 'SME owners across Southern Africa with 1-50 employees seeking affordable alternatives.',
			value_proposition: 'Handles cash transactions, multiple currencies, mobile money, and local taxes while being simple and affordable.',
			funding_stage: 'bootstrapped',
			funding_raised: 15_000,
			mentorship_areas: ['Go-to-market planning and launch', 'Marketing and branding', 'Sales and customer acquisition'],
			challenge_details: 'Completed MVP with 50 customers but growth is slow; needs marketing strategy and pricing optimization.',
			preferred_mentorship_mode: 'both',
			phone_number: '+260977123456',
			target_team_size: 11,
			founded_year: 2022
		}
	}
].freeze

def upsert_records(model, unique_key, rows)
	rows.each do |attributes|
		record = model.find_or_initialize_by(unique_key => attributes[unique_key])
		record.assign_attributes(attributes)
		record.save!
	end
end

require_relative 'seeds/programs'

HERO_SLIDES.each do |attrs|
	upsert_records(HeroSlide, :title, [attrs])
end

PARTNERS.each do |attrs|
	upsert_records(Partner, :name, [attrs])
end

TESTIMONIALS.each do |attrs|
	upsert_records(Testimonial, :author_name, [attrs])
end

PROGRAMS.each do |attrs|
	upsert_records(Program, :slug, [attrs])
end

FOCUS_AREAS.each do |attrs|
	upsert_records(FocusArea, :title, [attrs])
end

RESOURCES.each do |attrs|
	upsert_records(Resource, :title, [attrs])
end

MENTORS.each do |data|
	user = User.find_or_initialize_by(email: data[:email])
	user.password = SEED_USER_PASSWORD
	user.password_confirmation = SEED_USER_PASSWORD
	user.save!

	profile = UserProfile.find_or_initialize_by(user: user)
	profile.assign_attributes(
		role: 'mentor',
		full_name: data[:full_name],
		bio: data[:bio],
		title: data[:title],
		organization: data[:organization],
		location: data[:location],
		linkedin_url: data[:linkedin_url],
		years_experience: data[:years_experience],
		advisory_experience: data[:advisory_experience],
		sectors: data[:sectors],
		expertise: data[:expertise],
		stage_preference: data[:stage_preference],
		availability_hours_month: data[:availability_hours_month],
		rate_per_hour: data[:rate_per_hour],
		pro_bono: data[:pro_bono],
		preferred_mentorship_mode: data[:preferred_mentorship_mode],
		profile_visibility: data[:profile_visibility],
		onboarding_completed: data[:onboarding_completed],
		photo_url: data.fetch(:photo_url, 'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=400&q=80')
	)
	profile.save!
end

FOUNDERS.each do |data|
	user = User.find_or_initialize_by(email: data[:email])
	user.password = SEED_USER_PASSWORD
	user.password_confirmation = SEED_USER_PASSWORD
	user.save!

	profile = UserProfile.find_or_initialize_by(user: user)
	profile.assign_attributes(
		role: data[:role],
		full_name: data[:full_name],
		bio: data[:bio],
		location: data[:location],
		organization: data[:startup][:startup_name],
		sectors: data[:sectors],
		preferred_mentorship_mode: data[:preferred_mentorship_mode],
		onboarding_completed: true,
		profile_visibility: true,
		photo_url: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=400&q=80'
	)
	profile.save!

	startup_attrs = data[:startup]
	startup = StartupProfile.find_or_initialize_by(user: user)
	startup.assign_attributes(
		startup_name: startup_attrs[:startup_name],
		description: startup_attrs[:description],
		sector: startup_attrs[:sector],
		stage: startup_attrs[:stage],
		location: startup_attrs[:location],
		target_market: startup_attrs[:target_market],
		value_proposition: startup_attrs[:value_proposition],
		funding_stage: startup_attrs[:funding_stage],
		funding_raised: startup_attrs[:funding_raised],
		mentorship_areas: startup_attrs[:mentorship_areas],
		challenge_details: startup_attrs[:challenge_details],
		preferred_mentorship_mode: startup_attrs[:preferred_mentorship_mode],
		phone_number: startup_attrs[:phone_number],
		founded_year: startup_attrs[:founded_year],
		team_size: startup_attrs[:target_team_size],
		logo_url: "https://images.unsplash.com/photo-1521791136064-7986c2920216?auto=format&fit=crop&w=600&q=80",
		website_url: "https://#{startup_attrs[:startup_name].parameterize}.com"
	)
	startup.save!
end
