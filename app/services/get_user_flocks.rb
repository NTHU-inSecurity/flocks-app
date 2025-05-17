# frozen_string_literal: true

require 'http'

module FlocksServices
  # get user flocks
  class GetUserFlocks
    def initialize(config)
      @config = config
    end

    def call(current_account)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/api/v1/flocks/my")

      response.code == 200 ? JSON.parse(response.to_s)['data'] : []
    rescue StandardError => e
      puts "API Error: #{e.inspect}"
      []
    end
  end
end
