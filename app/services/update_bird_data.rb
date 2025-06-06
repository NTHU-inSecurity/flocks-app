# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class UpdateBird
      def initialize(config)
        @api_url = config.API_URL
      end

      def call(current_account:, flock_id:, bird_id:, latitude:, longitude:, message:)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .post("#{@api_url}/flocks/#{flock_id}/birds/#{bird_id}",
                             json: { message: message, latitude: latitude, longitude: longitude })

        raise('Could not update bird data') unless response.code == 200

        response.parse
      end
    end
  end
end
