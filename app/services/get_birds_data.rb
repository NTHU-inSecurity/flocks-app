# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class GetBirds # rubocop:disable Style/Documentation
      def initialize(config)
        @api_url = config.API_URL
      end

      def call(flock_id:)
        response = HTTP.get("#{@api_url}/flocks/#{flock_id}/birds")
        raise 'Could not retrieve birds data' unless response.code == 200

        response.parse['data']
      end
    end
  end
end
