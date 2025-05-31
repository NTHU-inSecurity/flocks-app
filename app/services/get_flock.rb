# frozen_string_literal: true

require 'http'

module Flocks
  # this class is for retrieving flock when user wants to join the flock
  class FlocksServices
    class GetFlock
      def initialize(config)
        @api_url = config.API_URL
      end

      def call(current_account:, flock_id:)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .get("#{@api_url}/flocks/#{flock_id}")
        raise 'Could not retrieve flock' unless response.code == 200

        response.parse
      end
    end
  end
end