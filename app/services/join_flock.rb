# frozen_string_literal: true

require 'http'

module Flocks
  # this class sends request to api to add user to flock
  class FlocksServices
    class JoinFlock # rubocop:disable Style/Documentation
      def initialize(config)
        @api_url = config.API_URL
      end

      # kurva ya perdolil
      def call(current_account:, flock_id:)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .post("#{@api_url}/flocks/#{flock_id}/birds")

        raise "Could not join flock: #{response.body}" unless response.code == 201

        response.parse['data']
      end
    end
  end
end
