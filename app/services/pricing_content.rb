class PricingContent
  DEFAULT_HERO = {
    title: "Pricing",
    subtitle: "Flexible plans for every stage of your startup journey. Choose the plan that fits your needs and scale with Nailab."
  }.freeze

  DEFAULT_TIERS = [
    {
      name: "Free",
      price: "Ksh 0",
      description: "Get started with Nailab and access our community, events, and select resources.",
      features: [
        "Access to Nailab community",
        "Monthly events & webinars",
        "Startup resources & guides",
        "Newsletter & updates"
      ],
      highlight: false,
      cta: "Get Started",
      cta_link: "/users/sign_up"
    },
    {
      name: "Basic",
      price: "Ksh 5,000",
      description: "Unlock mentorship, business clinics, and exclusive partner offers.",
      features: [
        "Everything in Free",
        "Mentorship sessions",
        "Business clinics",
        "Exclusive partner offers",
        "Priority event access"
      ],
      highlight: true,
      cta: "Start Basic",
      cta_link: "/users/sign_up"
    },
    {
      name: "Premium",
      price: "Ksh 15,000",
      description: "Full access to Nailab programs, investor network, and personalized support.",
      features: [
        "Everything in Basic",
        "Full program access",
        "Investor introductions",
        "Personalized support",
        "Pitch coaching",
        "Demo day invitations"
      ],
      highlight: false,
      cta: "Go Premium",
      cta_link: "/users/sign_up"
    }
  ].freeze

  class << self
    def tiers(structured_content)
      normalized = normalized_structured_content(structured_content)
      tiers = Array.wrap(normalized[:pricing_tiers]).map do |tier|
        tier = tier.with_indifferent_access
        tier[:features] = Array.wrap(tier[:features])
        tier[:highlight] = tier[:highlight].present? ? tier[:highlight] : false
        tier
      end
      tiers.presence || DEFAULT_TIERS
    end

    def hero(structured_content)
      normalized = normalized_structured_content(structured_content)
      # Ensure we merge with indifferent access so string-keyed JSON
      # keys override the symbol-keyed DEFAULT_HERO values.
      DEFAULT_HERO.with_indifferent_access.merge((normalized[:hero].presence || {})).with_indifferent_access
    end

    private

    def normalized_structured_content(content)
      case content
      when ActiveSupport::HashWithIndifferentAccess
        content
      when Hash
        content.with_indifferent_access
      else
        ActiveSupport::HashWithIndifferentAccess.new
      end
    end
  end
end
