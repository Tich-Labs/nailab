module Api
  module V1
    module Serializers
      class PartnerSerializer
        def initialize(partner)
          @partner = partner
        end

        def to_h
          {
            id: partner.id,
            name: partner.name,
            logo_url: partner.logo_url,
            website_url: partner.website_url,
            display_order: partner.display_order
          }
        end

        private

        attr_reader :partner
      end
    end
  end
end
