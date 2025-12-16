module Api
  module V1
    class PartnersController < PublicController
      def index
        partners = Partner.where(active: true).order(:display_order)
        render_collection(partners, Serializers::PartnerSerializer)
      end
    end
  end
end
