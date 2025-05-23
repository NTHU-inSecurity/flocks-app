# frozen_string_literal: true

require 'roda'
require_relative './app'

module Flocks
  # Web controller for Flocks API
  class App < Roda
    route('map') do |routing|
      routing.on do
        # GET /map
        routing.get do
          birds = FlocksServices::GetBirds.new(App.config).call(
            flock_id: routing.params['flock_id']
          )

          # FIX: controller knows too much
          bird = birds.find { |b| b['included']['account']['attributes']['username'] == @current_account.username }
          current_bird = { flock_id: bird['included']['flock']['attributes']['id'],
                           bird_id: bird['data']['attributes']['id'] }

          view :map, locals: { current_account: @current_account, birds:, bird: current_bird }
        end

        # POST /map/
        routing.post do
          data = JSON.parse(routing.body.read)

          FlocksServices::UpdateBird.new(App.config).call(
            flock_id: data['flock_id'],
            bird_id: data['bird_id'],
            latitude: data['latitude'],
            longitude: data['longitude'],
            message: data['message']
          )

          routing.redirect "/map?flock_id=#{data['flock_id']}"
        end
      end
    end
  end
end
