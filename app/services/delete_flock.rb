# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class DeleteFlock
      def initialize(config)
        @config = config
      end

      def call(flock_id:, current_account:)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .post("#{@config.API_URL}/bird/#{flock_id}")

        raise response.parse['message'] || 'Failed to delete or exit flock' unless response.code == 200

        true
      end
    end
  end
end
