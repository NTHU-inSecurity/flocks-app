# frozen_string_literal: true

require 'roda'
require_relative './app'

module Flocks
  # Web controller for Flocks API (map routes)
  class App < Roda
    route('map') do |routing|
      routing.on do
        # GET /map
        routing.get do
          birds_data = FlocksServices::GetBirds.new(App.config).call(
            current_account: @current_account,
            flock_id: routing.params['flock_id']
          )

          birds = Birds.new(birds_data)
          ws = WebSocket.new(App.config, routing.params['flock_id'])

          current_bird = birds.all.find do |b|
            b.account_name == @current_account.username && b.flock.id == routing.params['flock_id']
          end

          view :map,
               locals: {
                 current_account: @current_account,
                 flock_id: routing.params['flock_id'],
                 current_bird: current_bird,
                 ws: ws
               }
        end

        # POST /map/
        routing.post do
          data = JSON.parse(routing.body.read)

          FlocksServices::UpdateBird.new(App.config).call(
            current_account: @current_account,
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
