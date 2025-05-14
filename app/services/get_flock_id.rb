# frozen_string_literal: true

require 'http'

module Flocks
  class FlocksServices
    class GetFlocksID
        def initialize(config)
            @api_url = config.API_URL
          end
      
          def call(id)
            response = HTTP.get("#{@api_url}/flocks/#{id}")
            raise 'Could not retrieve flocks' unless response.code == 200
      
            response.parse
          end
      end
  end
end