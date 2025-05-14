# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class JoinFlock
      def initialize(config)
        @api_url = config.API_URL
      end

      def call(flock_id:, email:, username:, latitude:, longitude:)
        response = HTTP.post(
          "#{@api_url}/flocks/#{flock_id}/birds",
          json: {
            username: username,
            latitude_secure: latitude,
            longitude_secure: longitude,
            account: {
              attributes: {
                email: email
              }
            }
          }
        )

        raise "Could not join flock: #{response.body.to_s}" unless response.code == 201

        response.parse['data']
      end
    end
  end
end