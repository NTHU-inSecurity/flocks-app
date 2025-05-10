# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class CreateFlock
      def initialize(config)
        @api_url = config.API_URL
      end

      def call(email, destination_url:)
        response = HTTP.post(
          "#{@api_url}/flocks?email=#{email}",
          json: { destination_url: destination_url }
        )

        raise 'Could not create flock' unless response.code == 201

        response.parse['data']
      end
    end
  end
end