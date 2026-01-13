
# db/seeds/programs.rb
Rails.application.routes.default_url_options[:host] = 'localhost:3000' # for any links if needed

programs_data = [
  {
    title: "Innovate 4 Life",
    short_summary: "A regional maternal health accelerator supporting innovators across East and West Africa with mentorship, training, and funding to scale sustainable solutions improving maternal health outcomes.",
    description: <<~HTML,
      <p><strong>Supporting Maternal Health Innovation for a Healthier Africa</strong></p>
      <p>Partner: Amref</p>
      <p>Nailab, in partnership with Amref, launched the Innovate 4 Life program from 2017 to 2020 across Kenya, Uganda, and Nigeria. This initiative accelerated 15 impactful entrepreneurs from Sub-Saharan Africa, providing mentorship, training, and seed funding to scale maternal health solutions.</p>
      <p><strong>Impact in Kenya:</strong></p>
      <ul>
        <li>116 applications received</li>
        <li>4 entrepreneurs accelerated</li>
        <li>$210,000 invested in seed funding</li>
      </ul>
    HTML
    program_type: "Social Impact Programs",
    hero_image_url: "https://africasolutionsmediahub.org/wp-content/uploads/2025/02/women_s_health_in_Africa-2-1-scaled.jpg"
  },
  {
    title: "Let’s Hack Climate Change Hacklab",
    short_summary: "A youth-led hacklab addressing the intersection of climate change and sexual & reproductive health, providing coaching, mentorship, and seed funding to innovative solutions.",
    description: <<~HTML,
      <p><strong>Partner: UNFPA</strong></p>
      <p>In 2024, Nailab supported UNFPA's Let’s Hack Climate Change Hacklab, coaching 14 innovators from over 100 applicants. Through bootcamps and pitch events, two winners received $5,000 each, with one going on to win an additional $10,000 regionally in Kigali.</p>
      <p><strong>Impact:</strong></p>
      <ul>
        <li>100+ applications</li>
        <li>15 innovations incubated</li>
        <li>$20,000 seed funding invested</li>
      </ul>
    HTML
    program_type: "Masterclasses & Mentorship",
    hero_image_url: "https://jacobsladder.africa/wp-content/uploads/2023/06/Technology-for-Climate-Action-Hackathon.jpg"
  },
  {
    title: "Social Entrepreneurship Program (DHL & SOS)",
    short_summary: "Empowering youth SMEs with business management training, mentorship, and grant support for sustainable growth.",
    description: <<~HTML,
      <p><strong>Partners: DHL Foundation and SOS Children's Network</strong></p>
      <p>Nailab trained 40 young SMEs on financial management, marketing, business planning, and leadership, while managing grant distribution for transparent scaling.</p>
    HTML
    program_type: "Masterclasses & Mentorship",
    hero_image_url: "https://fosda.org/wp-content/uploads/2022/11/YES-PRJ-147-scaled.jpg"
  },
  {
    title: "Bankika Istart Youth Challenge",
    short_summary: "Igniting youth entrepreneurship with mentorship, training, and investor readiness for self-reliance.",
    description: <<~HTML,
      <p><strong>Partner: KCB Bank Group</strong></p>
      <p>Provided incubation, mentorship, and pitch training to 100 finalists under the #2jiajiri movement.</p>
    HTML
    program_type: "Masterclasses & Mentorship",
    hero_image_url: "https://africasustainabilitymatters.com/wp-content/uploads/2019/10/YOUNG-AFRICAN-LEADERS-87.jpg"
  },
  {
    title: "Make-IT Accelerator",
    short_summary: "A 9-month tech accelerator across Africa providing mentorship, corporate partnerships, and investment readiness support.",
    description: <<~HTML,
      <p><strong>Partner: GIZ</strong></p>
      <p>Structured in three phases: Inspire (capacity building), Corporate partnerships, and Develop (investment readiness). Supported entrepreneurs in Kenya, Rwanda, Uganda, and Mozambique.</p>
      <p><strong>Impact:</strong></p>
      <ul>
        <li>190 applications</li>
        <li>30 entrepreneurs trained</li>
        <li>$660,000 invested</li>
      </ul>
    HTML
    program_type: "Startup Incubation & Acceleration",
    hero_image_url: "https://cchub.africa/wp-content/uploads/2017/11/make-it-600.jpg"
  },
  {
    title: "The Next Economy Program",
    short_summary: "Upskilling disadvantaged youth for employability and entrepreneurship across multiple cohorts.",
    description: <<~HTML,
      <p><strong>Partners: SOS Netherlands, SOS Kenya, GoodUp</strong></p>
      <p>Four cohorts focused on life skills, employability, and entrepreneurship.</p>
      <p><strong>Impact:</strong></p>
      <ul>
        <li>10,253 applications</li>
        <li>4,895 young people trained</li>
        <li>$1,435,680 invested</li>
      </ul>
    HTML
    program_type: "Startup Incubation & Acceleration",
    hero_image_url: "https://media.licdn.com/dms/image/v2/D4D12AQFamOVsZd7ymQ/article-cover_image-shrink_720_1280/article-cover_image-shrink_720_1280/0/1709543877568?e=2147483647&v=beta&t=FznYfv9C8FM5HDgM9-cJbIcuvZedJ9LRnporx8lLJWI"
  },
  {
    title: "I AM Accelerator",
    short_summary: "Accelerating youth-friendly SRH solutions across East Africa with mentorship and seed funding.",
    description: <<~HTML,
      <p><strong>Partners: Graça Machel Trust, UNFPA</strong></p>
      <p>Supported 28 entrepreneurs across Kenya, Uganda, Tanzania, and Rwanda.</p>
      <p><strong>Impact:</strong></p>
      <ul>
        <li>28 entrepreneurs accelerated</li>
        <li>$804,000 invested</li>
      </ul>
    HTML
    program_type: "Startup Incubation & Acceleration",
    hero_image_url: "https://miro.medium.com/v2/resize:fit:1400/1*XGDN42Mcin1E_X3-DEMbeQ.jpeg"
  },
  {
    title: "develoPPP Venture Kenya",
    short_summary: "Scaling social impact ventures with €200,000 grants and technical assistance.",
    description: <<~HTML,
      <p><strong>Partners: KFW, DEG, SeedStars</strong></p>
      <p>Two cohorts supporting 20 entrepreneurs.</p>
      <p><strong>Impact:</strong></p>
      <ul>
        <li>250,000 applications</li>
        <li>20 businesses accelerated (€200,000 each)</li>
      </ul>
    HTML
    program_type: "Funding Access",
    hero_image_url: "https://www.techloy.com/content/images/2025/04/INFOGRAPHIC-Startup-Funding-in-Africa-and-the-Middle-East---Week-15--2025.png"
  },
  {
    title: "Africa Netpreneur Prize Initiative (Year One)",
    short_summary: "Continent-wide pitch competition with $1M annual prizes supporting African entrepreneurs.",
    description: <<~HTML,
      <p><strong>Partner: Jack Ma Foundation</strong></p>
      <p>Nailab led implementation in 2019, reaching 50 countries.</p>
      <p><strong>Impact:</strong></p>
      <ul>
        <li>10,000 applications</li>
        <li>10 finalists ($65K–$250K prizes)</li>
      </ul>
    HTML
    program_type: "Funding Access",
    hero_image_url: "https://media.licdn.com/dms/image/v2/D4D12AQGGj99FQ0RuQA/article-cover_image-shrink_720_1280/B4DZU8YCnsHkAU-/0/1740474696208?e=2147483647&v=beta&t=Wf8xqmUhBWMnEHi8YvN8VS9tkpOmIf6vSoe1edecbCQ"
  },
  {
    title: "LEAP² Challenge",
    short_summary: "Crowdfunding challenges with matching funds for circular economy, women in tech, and fintech innovations.",
    description: <<~HTML,
      <p><strong>Partners: Close the Gap, GoodUp</strong></p>
      <p>Three programs (2018-2019) with €100,000 total matching funds for 22 entrepreneurs.</p>
    HTML
    program_type: "Funding Access",
    hero_image_url: "https://www.techinafrica.com/wp-content/uploads/2025/04/84ff12b9-5382-4086-8205-708a1114f611_3500x1969.webp"
  },
  {
    title: "Recognized Prior Learning (RPL) Study",
    short_summary: "Research mapping digital platforms for informal skills recognition and workforce linkages in Africa.",
    description: <<~HTML,
      <p><strong>Partners: African Union Development Agency, SIFA-GIZ</strong></p>
      <p>2020 desk study providing a blueprint for inclusive workforce development through RPL platforms.</p>
    HTML
    program_type: "Research & Development",
    hero_image_url: "https://aaeafrica.org/wp-content/uploads/2020/10/ecosystem.png"
  },
  {
    title: "The IDEA Initiative Africa",
    short_summary: "Co-creating innovative SRHR advocacy solutions with youth, artists, and creatives.",
    description: <<~HTML,
      <p><strong>Partner: Planned Parenthood Global</strong></p>
      <p>Two cohorts (2022-2023) supporting 40 innovators with $20,000 shared seed funding for top ideas.</p>
      <p><strong>Impact:</strong></p>
      <ul>
        <li>220 applications</li>
        <li>40 innovators incubated</li>
      </ul>
    HTML
    program_type: "Social Impact Programs",
    hero_image_url: "https://lookaside.instagram.com/seo/google_widget/crawler/?media_id=3682232877071840990"
  },
  {
    title: "SRHR & SGBV e-Learning Platform",
    short_summary: "Animated training modules for police on handling GBV and FGM cases.",
    description: <<~HTML,
      <p><strong>Partners: Women Empowerment Link, National Police Service, UNFPA</strong></p>
      <p>Developed interactive e-learning content aligned with national protocols to improve law enforcement response to gender-based violence.</p>
    HTML
    program_type: "Social Impact Programs",
    hero_image_url: "https://www.worldbank.org/content/dam/photos/780x439/2023/nov/GBV-event-2023.png"
  }
]


programs_data.each do |data|
  slug = data[:title].parameterize
  program = Program.find_or_create_by!(slug: slug) do |p|
    p.title = data[:title]
    p.short_summary = data[:short_summary]
    p.description = ActionText::Content.new(data[:description])
    p.program_type = data[:program_type]
    p.status = :completed
  end

  # Attach hero image if not already attached
  if program.respond_to?(:hero_image) && program.hero_image.blank? && data[:hero_image_url].present?
    program.hero_image.attach(
      io: URI.open(data[:hero_image_url]),
      filename: "#{program.title.parameterize}-hero.jpg"
    )
  end
end

puts "Seeded #{Program.count} programs with hero images attached!"
