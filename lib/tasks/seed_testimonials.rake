namespace :seed do
  desc "Seed testimonials from HTML snippet"
  task testimonials: :environment do
    data = [
      {
        author_name: "Omar Shoukry Sakr",
        quote: "Winning 2nd place in the Africa Netpreneur Prize Initiative (ANPI) 2019 constituted a major milestone in my startup journey. But beyond the cash prize, the exposure, networks, and partnerships I gained through the Nailab network proved far more valuable in scaling Nawah Scientific.",
        author_role: "Founder and CEO",
        organization: "Nawah Scientific",
        website_url: "https://www.nawah-scientific.com/",
        photo_url: "https://nailab-static.s3.eu-north-1.amazonaws.com/images/Omar_Shoukry_Sakr.original.jpg",
        display_order: 1,
        active: true
      },
      {
        author_name: "Munira Twahir",
        quote: "Being part of the I AM program in 2018-2019 not only helped me secure funding for my product development but the mentorship I received from the Nailab team of mentors was invaluable in refining our business model.",
        author_role: "Founder and CEO",
        organization: "Ari",
        website_url: "http://inteco.co.ke/",
        photo_url: "https://nailab-static.s3.eu-north-1.amazonaws.com/images/munira_twahir.original.jpg",
        display_order: 2,
        active: true
      },
      {
        author_name: "Gabriel Mwaingo",
        quote: "Before joining Nailab in 2024, we had a great idea and passion but lacked the experience of running a business. Through one-on-one mentorship on pitching, product–market fit, and customer discovery, Nailab helped us transform that passion into a market-ready product.",
        author_role: "Founder and CEO",
        organization: "Eco Print Generation",
        website_url: "https://www.linkedin.com/company/eco-prints-generation/posts/?feedView=all",
        photo_url: "https://nailab-static.s3.eu-north-1.amazonaws.com/images/gabriel_mwaingo.original.jpg",
        display_order: 3,
        active: true
      },
      {
        author_name: "Janet Dete",
        quote: "Through my interaction with the Nailab team and mentors during the Global Student Entrepreneur Awards (GSEA) program in 2024-2025, I learned how to articulate my venture clearly and impactfully, making it resonate with investors. I gained valuable skills in crafting a compelling pitch that highlights the social and environmental impact of Queening Afrika.",
        author_role: "Founder and CEO",
        organization: "Queening Afrika",
        website_url: "https://queeningafrika.com/",
        photo_url: "https://nailab-static.s3.eu-north-1.amazonaws.com/images/janet_dete.original.jpg",
        display_order: 4,
        active: true
      }
    ]

    puts "Seeding #{data.size} testimonials..."

    data.each do |attrs|
      t = Testimonial.find_or_initialize_by(author_name: attrs[:author_name])
      t.assign_attributes(attrs.except(:author_name))
      if t.save
        puts "  - saved: #{t.author_name}"
      else
        puts "  - failed: #{t.author_name} -> #{t.errors.full_messages.join(', ')}"
      end
    end

    puts "Done."
  end
end
