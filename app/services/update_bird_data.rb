# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class UpdateBird
        def initialize(config)
            @api_url = config.API_URL
          end

      def call(flock_id:, bird_id:, latitude:, longitude:, message:)
        response = HTTP.post("#{@api_url}/flocks/#{flock_id}/birds/#{bird_id}",
                             json: { message: message, latitude: latitude, longitude: longitude})

        raise(UnauthorizedError) unless response.code == 200

        response.parse['attributes']
      end
    end
  end
end
