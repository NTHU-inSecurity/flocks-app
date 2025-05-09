# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class GetFlocks
        def initialize(config)
            @api_url = config.API_URL
          end
      
          def all
            response = HTTP.get("#{@api_url}/flocks")
            raise 'Could not retrieve flocks' unless response.code == 200
      
            response.parse['data']
          end
      end
  end
end