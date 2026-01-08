module Admin
  module PricingPage
    class SectionsController < ApplicationController
      before_action :load_pricing_tiers

      def edit
      end

      def update
        # Save logic for pricing tiers (stub, implement as needed)
        # Example: save to YAML, DB, or another persistent store
        flash[:notice] = "Pricing tiers updated (stub)."
        redirect_to admin_pricing_page_sections_edit_path
      end

      private
      def load_pricing_tiers
        @pricing_tiers = [
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
            cta: "Get Started",
            cta_link: "#",
            highlight: false
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
            cta: "Start Basic",
            cta_link: "#",
            highlight: true
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
            cta: "Go Premium",
            cta_link: "#",
            highlight: false
          }
        ]
      end
    end
  end
end
