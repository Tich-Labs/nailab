# db/seeds/resources.rb

resources_data = [
  {
    title: "Startup Funding Guide",
    description: "A comprehensive guide to securing funding for your startup in Africa.",
    url: "https://example.com/startup-funding-guide",
    resource_type: "guide",
    published_at: 1.month.ago,
    active: true
  },
  {
    title: "Mentorship Best Practices",
    description: "Learn how to make the most of mentorship relationships.",
    url: "https://example.com/mentorship-best-practices",
    resource_type: "article",
    published_at: 2.weeks.ago,
    active: true
  },
  {
    title: "Business Model Canvas Template",
    description: "Downloadable template for creating your business model canvas.",
    url: "https://example.com/bmc-template",
    resource_type: "template",
    published_at: 3.days.ago,
    active: true
  },
  {
    title: "Pitch Deck Workshop Recording",
    description: "Recorded session on creating effective pitch decks.",
    url: "https://example.com/pitch-deck-workshop",
    resource_type: "video",
    published_at: 1.week.ago,
    active: true
  }
]

resources_data.each do |resource_attrs|
  resource = Resource.find_or_initialize_by(title: resource_attrs[:title])
  resource.assign_attributes(resource_attrs)
  resource.save!
end

puts "✅ Seeded Resources."
