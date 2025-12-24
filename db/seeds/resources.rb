# db/seeds/resources.rb
#
# Seed sample resources for different types: blogs, webinars, events, opportunities, templates, knowledge_hub
#

puts "Seeding resources..."

# Sample blog posts
blog_resources = [
  {
    title: "Building Your First Startup: A Founder's Guide",
    description: "Essential steps and lessons learned from launching a successful tech startup.",
    content: "<p>Starting a startup is an exciting but challenging journey. This comprehensive guide covers everything from ideation to launch, with practical tips and real-world examples.</p><h2>Key Takeaways</h2><ul><li>Validate your idea early</li><li>Build an MVP quickly</li><li>Focus on customer feedback</li><li>Scale strategically</li></ul>",
    resource_type: "blog",
    category: "Entrepreneurship",
    author: "Sarah Chen",
    url: "https://nailab.com/blog/building-first-startup",
    published_at: 2.weeks.ago,
    active: true
  },
  {
    title: "The Future of AI in Healthcare",
    description: "Exploring how artificial intelligence is transforming medical diagnosis and treatment.",
    content: "<p>AI is revolutionizing healthcare with unprecedented accuracy in diagnostics and personalized treatment plans. Learn about the latest breakthroughs and their implications.</p>",
    resource_type: "blog",
    category: "Technology",
    author: "Dr. Michael Rodriguez",
    url: "https://nailab.com/blog/ai-healthcare-future",
    published_at: 1.week.ago,
    active: true
  },
  {
    title: "Mentorship Best Practices for Tech Leaders",
    description: "How to be an effective mentor and build strong relationships with your mentees.",
    content: "<p>Effective mentorship can accelerate career growth and foster innovation. Discover proven strategies for successful mentor-mentee relationships.</p>",
    resource_type: "blog",
    category: "Leadership",
    author: "Jennifer Park",
    url: "https://nailab.com/blog/mentorship-best-practices",
    published_at: 3.days.ago,
    active: true
  }
]

# Sample webinars
webinar_resources = [
  {
    title: "Scaling Your SaaS Business: From 0 to 100 Customers",
    description: "Live webinar on growth strategies for SaaS startups.",
    content: "<p>Join our expert panel as they discuss proven strategies for scaling SaaS businesses. Learn about customer acquisition, retention, and revenue optimization.</p><p><strong>Date:</strong> March 15, 2024<br><strong>Time:</strong> 2:00 PM EST<br><strong>Duration:</strong> 90 minutes</p>",
    resource_type: "webinar",
    category: "Business Growth",
    author: "NailaB Team",
    url: "https://nailab.com/webinars/saas-scaling",
    published_at: 1.month.ago,
    active: true
  },
  {
    title: "Introduction to Machine Learning for Entrepreneurs",
    description: "A beginner-friendly webinar on ML concepts and applications.",
    content: "<p>Demystify machine learning and discover how it can give your startup a competitive edge. No technical background required.</p>",
    resource_type: "webinar",
    category: "Technology",
    author: "Dr. Lisa Thompson",
    url: "https://nailab.com/webinars/ml-for-entrepreneurs",
    published_at: 2.weeks.ago,
    active: true
  }
]

# Sample events
event_resources = [
  {
    title: "NailaB Annual Founder Summit 2024",
    description: "Connect with fellow founders, learn from industry leaders, and accelerate your startup journey.",
    content: "<p>The NailaB Annual Founder Summit brings together entrepreneurs, investors, and industry experts for an unforgettable day of learning and networking.</p><h3>Agenda Highlights:</h3><ul><li>Keynote speeches from successful founders</li><li>Panel discussions on current trends</li><li>Networking sessions</li><li>Workshop on fundraising strategies</li></ul><p><strong>Date:</strong> April 20, 2024<br><strong>Location:</strong> San Francisco, CA<br><strong>Cost:</strong> $99 (early bird)</p>",
    resource_type: "event",
    category: "Networking",
    author: "NailaB Events Team",
    url: "https://nailab.com/events/founder-summit-2024",
    published_at: 1.month.ago,
    active: true
  },
  {
    title: "Women in Tech Meetup",
    description: "Monthly meetup for women in technology to share experiences and support each other.",
    content: "<p>A supportive community for women in tech to connect, share experiences, and advance their careers together.</p>",
    resource_type: "event",
    category: "Community",
    author: "Maria Gonzalez",
    url: "https://nailab.com/events/women-in-tech-meetup",
    published_at: 1.week.ago,
    active: true
  }
]

# Sample opportunities
opportunity_resources = [
  {
    title: "Senior Software Engineer - AI Startup",
    description: "Join a fast-growing AI company working on cutting-edge machine learning solutions.",
    content: "<p>We're looking for a talented software engineer to join our AI team. You'll work on developing innovative ML solutions that impact millions of users.</p><h3>Requirements:</h3><ul><li>3+ years of software engineering experience</li><li>Experience with Python and ML frameworks</li><li>Strong problem-solving skills</li><li>Team player with excellent communication</li></ul><p><strong>Location:</strong> Remote<br><strong>Salary:</strong> $120k - $160k<br><strong>Equity:</strong> 0.5-1.0%</p>",
    resource_type: "opportunity",
    category: "Engineering",
    author: "TechCorp AI",
    url: "https://nailab.com/opportunities/senior-software-engineer",
    published_at: 3.days.ago,
    active: true
  },
  {
    title: "Product Manager - FinTech Startup",
    description: "Lead product strategy for a revolutionary financial technology platform.",
    content: "<p>Shape the future of financial services by leading product development for our innovative fintech platform.</p>",
    resource_type: "opportunity",
    category: "Product",
    author: "FinTech Innovations",
    url: "https://nailab.com/opportunities/product-manager-fintech",
    published_at: 1.week.ago,
    active: true
  }
]

# Sample knowledge hub articles
knowledge_hub_resources = [
  {
    title: "Startup Funding Options: A Complete Guide",
    description: "Comprehensive overview of different funding sources available to startups.",
    content: "<p>Understanding your funding options is crucial for startup success. This guide covers everything from bootstrapping to venture capital.</p><h2>Types of Funding:</h2><h3>1. Bootstrapping</h3><p>Self-funding your startup using personal savings or revenue.</p><h3>2. Friends and Family</h3><p>Raising money from personal networks.</p><h3>3. Angel Investors</h3><p>Individual investors who provide capital for equity.</p><h3>4. Venture Capital</h3><p>Institutional investors who fund high-growth startups.</p>",
    resource_type: "knowledge_hub",
    category: "Funding",
    author: "Robert Kim",
    url: "https://nailab.com/knowledge/funding-options-guide",
    published_at: 2.weeks.ago,
    active: true
  },
  {
    title: "Building a Strong Company Culture",
    description: "Strategies for creating and maintaining a positive workplace culture.",
    content: "<p>Company culture is the foundation of successful organizations. Learn how to build and nurture a culture that drives performance and employee satisfaction.</p>",
    resource_type: "knowledge_hub",
    category: "Culture",
    author: "Amanda Foster",
    url: "https://nailab.com/knowledge/company-culture",
    published_at: 1.week.ago,
    active: true
  }
]

# Sample templates
template_resources = [
  {
    title: "Business Model Canvas Template",
    description: "A strategic tool to help you map out and align your business model.",
    content: "<p>The Business Model Canvas is a strategic management template for developing new or documenting existing business models.</p><p>This template includes all 9 building blocks: Key Partners, Key Activities, Key Resources, Value Propositions, Customer Relationships, Channels, Customer Segments, Cost Structure, and Revenue Streams.</p>",
    resource_type: "template",
    category: "Business Planning",
    author: "Strategy Team",
    url: "https://nailab.com/templates/business-model-canvas",
    published_at: 3.weeks.ago,
    active: true
  },
  {
    title: "Pitch Deck Template for Startups",
    description: "Professional pitch deck template to impress investors and stakeholders.",
    content: "<p>A comprehensive pitch deck template that covers all essential slides for a compelling investor presentation.</p><p>Includes sections for: Company Overview, Problem, Solution, Market Opportunity, Product, Traction, Team, Financials, and Ask.</p>",
    resource_type: "template",
    category: "Fundraising",
    author: "Design Team",
    url: "https://nailab.com/templates/pitch-deck",
    published_at: 2.weeks.ago,
    active: true
  }
]

# Create all resources
all_resources = blog_resources + webinar_resources + event_resources + opportunity_resources + knowledge_hub_resources + template_resources

all_resources.each do |resource_attrs|
  Resource.find_or_create_by!(title: resource_attrs[:title]) do |resource|
    SeedHelpers.safe_assign(resource, resource_attrs)
  end
end

puts "Created #{all_resources.size} sample resources"