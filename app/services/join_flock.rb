# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class JoinFlock
      def initialize(config)
        @api_url = config.API_URL
      end

      def call(flock_id:, username:, latitude: '0.0000', longitude: '0.0000', message: '')
        response = HTTP.post(
          "#{@api_url}/flocks/#{flock_id}/birds",
          json: {
            latitude: latitude,
            longitude: longitude,
            message: message,
            account: {
              attributes: {
                username: username
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