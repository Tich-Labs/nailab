namespace :about do
  desc "Seed AboutPage.content with default sections (mission, vision, what_drives_us, why_nailab, our_impact)"
  task seed_defaults: :environment do
    about = AboutPage.first_or_create!(title: "About")
    stored = {}
    if about.content.present?
      begin
        stored = JSON.parse(about.content) rescue {}
      rescue => _e
        stored = {}
      end
    end

    stored["why_nailab_exists"] ||= {
      "title" => "Why Nailab Exists",
      "paragraph_one" => "Limited access to capital and knowledge are among the biggest challenges African founders face when launching their startups. In Africa, Nailab is changing that narrative by lowering the barriers to entry for tech founders looking to start and scale their businesses.",
      "paragraph_two" => "For over a decade, we have supported founders with the skills, mentorship, and funding they need to build scalable, impact-driven businesses that tackle Africa's most pressing challenges. Through strategic partnerships and tailored coaching programs, we create an enabling environment where startups can succeed — connecting them with investors, mentors, and key networks.",
      "paragraph_three" => "At Nailab, we believe in the power of African-led solutions to transform industries and uplift communities."
    }

    stored["our_impact"] ||= {
      "title" => "Our Impact",
      "description" => "We partner with founders, mentors and partners to support startups across Africa.",
      "stats" => [
        { "value" => "10+", "label" => "Years of Impact" },
        { "value" => "54", "label" => "African Countries" },
        { "value" => "30+", "label" => "Innovation Programs" },
        { "value" => "$100M", "label" => "Funding Facilitated" },
        { "value" => "1000", "label" => "Startups Supported" },
        { "value" => "50+", "label" => "Partners" }
      ]
    }

    stored["our_mission"] ||= { "title" => "Our Mission", "description" => "To be Africa's leading launchpad, empowering bold innovators with the knowledge, mentorship, and community to turn their ideas into scalable, tech-driven solutions that drive economic growth and address the continent's most pressing challenges." }
    stored["our_vision"] ||= { "title" => "Our Vision", "description" => "To build an inclusive network that supports African founders through a collaborative platform where mentors, investors, and founders work together to scale innovative, tech-driven startups." }

    stored["what_drives_us"] ||= {
      "title" => "What Drives Us",
      "cards" => [
        { "id" => "entrepreneur-first", "title" => "Entrepreneur-First", "description" => "We prioritize the needs and growth of African entrepreneurs by offering support that is tailored, relevant, and results-driven." },
        { "id" => "innovation-for-impact", "title" => "Innovation for Impact", "description" => "We champion bold thinking and creative solutions that address real-world challenges and deliver lasting, meaningful change across communities and sectors." },
        { "id" => "inclusion", "title" => "Inclusion", "description" => "We strive to ensure that opportunities are accessible to all, ensuring that innovators of all backgrounds, especially youth and women, have equal access to resources and support they need." },
        { "id" => "collaboration", "title" => "Collaboration", "description" => "We believe in the power of partnerships and collective action to drive greater impact and scale solutions across Africa." },
        { "id" => "integrity", "title" => "Integrity", "description" => "We operate with transparency, accountability, and a commitment to ethical practices in all that we do." },
        { "id" => "continuous-learning", "title" => "Continuous Learning", "description" => "We foster a culture of curiosity, experimentation, and growth, always seeking to learn and improve." }
      ]
    }

    about.update!(content: stored.to_json)
    puts "Seeded AboutPage.content with defaults"
  end
end
