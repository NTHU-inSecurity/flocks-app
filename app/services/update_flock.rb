# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class UpdateFlock
      def initialize(config)
        @config = config
      end

      def call(flock_id, destination_url, current_account)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .post("#{@config.API_URL}/flocks/#{flock_id}", json: {
                         destination_url: destination_url
                       })

        raise response.parse['message'] || 'Failed to update flock' unless response.code == 200

        response.parse['data']
      end
    end
  end
end