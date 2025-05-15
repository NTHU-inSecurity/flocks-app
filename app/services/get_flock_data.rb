# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class GetFlocks
        def initialize(config)
            @api_url = config.API_URL
          end
      
          def call(username)
            response = HTTP.get("#{@api_url}/flocks?username=#{username}")
            raise 'Could not retrieve flocks' unless response.code == 200
      
            response.parse['data']
          end
      end
  end
end