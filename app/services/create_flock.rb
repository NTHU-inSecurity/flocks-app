# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class CreateFlock
      def initialize(config)
        @config = config
      end

      def call(destination_url:, current_account:)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .post("#{@config.API_URL}/flocks", json: { destination_url: })

        # response.code == 201 ? JSON.parse(response.to_s)['data'] : nil

        raise 'Could not create flock' unless response.code == 201

        response.parse['data']
      end
    end
  end
end
