# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class DeleteFlock # rubocop:disable Style/Documentation
      def initialize(config)
        @config = config
      end

      def call(flock_id, current_account)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .delete("#{@config.API_URL}/flocks/#{flock_id}")

        raise response.parse['message'] || 'Failed to delete flock' unless response.code == 200

        true
      end
    end
  end
end