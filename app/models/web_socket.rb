# frozen_string_literal: true

module Flocks
  class WebSocket
    def initialize(config, flock_id)
      @config = config
      @flock_id = flock_id
    end

    def ws_channel_id
      @flock_id
    end

    def ws_javascript
      "#{@config.WS_URL}/faye.js"
    end

    def ws_route
      @config.WS_URL
    end
  end
end
