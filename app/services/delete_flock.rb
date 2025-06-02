# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class DeleteFlock # rubocop:disable Style/Documentation
      def initialize(config)
        @config = config
      end

      def call(flock_id, current_account)
        # birds_response = HTTP.auth("Bearer #{current_account.auth_token}")
        #                      .get("#{@config.API_URL}/flocks/#{flock_id}/birds")

        # raise 'Could not retrieve bird data' unless birds_response.code == 200
        # birds = birds_response.parse['data']

        # unless birds.any? { |bird|
        #   bird.dig('included', 'account', 'attributes', 'username') == current_account.username
        # }
        #   raise 'You are not a member of this flock'
        # end

        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .post("#{@config.API_URL}/bird/#{flock_id}")

        raise response.parse['message'] || 'Failed to delete or exit flock' unless response.code == 200

        true
      end
    end
  end
end
