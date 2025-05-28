# frozen_string_literal: true

require 'roda'
require_relative 'app'

module Flocks
  class App < Roda # rubocop:disable Style/Documentation
    route('flock') do |routing| # rubocop:disable Metrics/BlockLength
      # GET /flock/all
      routing.is 'all' do
        flocks = FlocksServices::GetFlocks.new(App.config).call(@current_account)
        view :flocks, locals: { flocks:, current_account: @current_account }
      end

      # GET /flock/share/[ID]
      routing.on 'share', String do |flock_id|
        flock_data = FlocksServices::GetFlockID.new(App.config).call(flock_id)
        view :share_flocks, locals: { flock: flock_data, current_account: @current_account }
      rescue StandardError => e
        flash[:error] = e.message
        response.status = 400
        routing.redirect '/'
      end

      # POST /flock/join/[id]
      routing.on 'join', String do |flock_id|
        routing.post do
          username = @current_account.username
          FlocksServices::JoinFlock.new(App.config).call(
            flock_id:,
            username:
          )
          flash[:notice] = 'You have successfully joined the flock!'
          routing.redirect "/flock/share/#{flock_id}"
        rescue StandardError => e
          flash[:error] = "Could not join the flock: #{e.message}"
          routing.redirect '/'
        end
      end

      # GET and POST /flock/create
      routing.is 'create' do
        routing.get do
          view :create_flock, locals: { current_account: @current_account }
        end

        routing.post do
          # ASK: WHY check if logged in??
          unless @current_account&.logged_in?
            flash[:error] = 'Please register first'
            routing.redirect '/auth/login'
          end

          destination_url = routing.params['destination_url']

          FlocksServices::CreateFlock.new(App.config).call(
            destination_url, @current_account
          )

          flash[:notice] = 'Flock created successfully'
          routing.redirect '/flock/all'
        rescue StandardError => e
          flash.now[:error] = e.message
          response.status = 400
          view :create_flock, locals: { current_account: @current_account }
        end
      end

      # PUT/POST /flock/[flock_id]/bird/[bird_id]/update
      routing.on String do |flock_id|
        routing.on 'bird', String do |bird_id|
          routing.on 'update' do
            routing.post do
              unless @current_account&.logged_in?
                flash[:error] = 'Please login first'
                routing.redirect '/auth/login'
              end

              message = routing.params['message'] || ''
              latitude = routing.params['latitude']&.to_f
              longitude = routing.params['longitude']&.to_f

              FlocksServices::UpdateBird.new(App.config).call(
                flock_id:,
                bird_id:,
                latitude:,
                longitude:,
                message:
              )

              flash[:notice] = 'Message updated successfully!'
              routing.redirect "/flock/share/#{flock_id}"
            rescue StandardError => e
              flash[:error] = "Could not update message: #{e.message}"
              routing.redirect "/flock/share/#{flock_id}"
            end
          end
        end
      end
    end
  end
end
