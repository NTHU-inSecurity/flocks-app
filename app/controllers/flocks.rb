# frozen_string_literal: true

require 'roda'
require_relative './app'

module Flocks
  class App < Roda
    route('flock') do |routing|
      # GET /flock/all
      routing.is 'all' do
        flocks = FlocksServices::GetFlocks.new(App.config).all(@current_account['email'])
        view :flocks, locals: { flocks:, current_account: @current_account }
      end

      # GET and POST /flock/create
      routing.is 'create' do
        routing.get do
          view :create_flock, locals: { current_account: @current_account }
        end

        routing.post do
          destination_url = routing.params['destination_url']
          new_flock = FlocksServices::CreateFlock.new(App.config).call(@current_account['email'], destination_url:)

          flash[:notice] = 'Flock created successfully'
          routing.redirect '/flock/all'
        rescue StandardError => e
          flash.now[:error] = e.message
          response.status = 400
          view :create_flock, locals: { current_account: @current_account }
        end
      end
    end
  end
end