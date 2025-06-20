# frozen_string_literal: true

require 'http'

module Flocks
  # this class request all flocks joined by user
  class FlocksServices
    class GetFlocks
      def initialize(config)
        @config = config
      end

      def call(current_account)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .get("#{@config.API_URL}/flocks")

        response.code == 200 ? JSON.parse(response.to_s)['data'] : nil
      end
    end
  end
end
