module Db
  module SpCost
    class AddSpCost
      TOKEN_WHITELIST = %i[
        acuant_front_image
        acuant_back_image
        aamva
        authentication
        digest
        ial1_user_added
        ial2_user_added
        lexis_nexis_resolution
        lexis_nexis_address
        gpo_letter
        phone_otp
        sms
        voice
      ].freeze

      def self.call(issuer, token)
        return if issuer.nil? || token.blank?
        return unless TOKEN_WHITELIST.index(token.to_sym)
        sp = ServiceProvider.find_by(issuer: issuer)
        agency_id = sp ? sp.agency_id : 0
        ::SpCost.create(issuer: issuer, agency_id: agency_id.to_i, cost_type: token)
      end
    end
  end
end
