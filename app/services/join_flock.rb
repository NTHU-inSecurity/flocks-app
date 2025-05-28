# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class JoinFlock # rubocop:disable Style/Documentation
      def initialize(config)
        @api_url = config.API_URL
      end

      def call(flock_id:, username:, latitude: '0.0000', longitude: '0.0000', message: '') # rubocop:disable Metrics/MethodLength
        response = HTTP.post(
          "#{@api_url}/flocks/#{flock_id}/birds",
          json: {
            latitude:,
            longitude:,
            message:,
            account: {
              attributes: {
                username:
              }
            }
          }
        )

        raise "Could not join flock: #{response.body}" unless response.code == 201

        response.parse['data']
      end
    end
  end
end
