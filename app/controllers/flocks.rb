# frozen_string_literal: true

require 'roda'
require_relative 'app'

module Flocks
  class App < Roda
    route('flock') do |routing|
      # GET /flock/all
      routing.is 'all' do
        flocks = FlocksServices::GetFlocks.new(App.config).all
        view :flocks, locals: { flocks:, current_account: @current_account }
      end

      # GET /flock/share/[ID]
      routing.on 'share', String do |flock_id|
        begin
          flock_data = FlocksServices::GetFlockID.new(App.config).call(flock_id)
          view :share_flocks, locals: { flock: flock_data, current_account: @current_account }
        rescue StandardError => e
          flash[:error] = e.message
          response.status = 400
          routing.redirect '/'
        end
      end

      # POST /flock/join/[id]
      routing.on 'join', String do |flock_id|
        routing.post do
          begin
            username = @current_account['username']
            FlocksServices::JoinFlock.new(App.config).call(
              flock_id: flock_id,
              username: username
            )
            flash[:notice] = 'You have successfully joined the flock!'
            routing.redirect "/flock/share/#{flock_id}"
          rescue StandardError => e
            flash[:error] = "Could not join the flock: #{e.message}"
            routing.redirect '/'
          end
        end
      end

      # GET /flock/my - current_account flocks
      routing.is 'my' do
        unless @current_account&.logged_in?
          flash[:error] = 'please login first'
          routing.redirect '/auth/login'
        end

        flocks = FlocksServices::GetUserFlocks.new(App.config)
                                              .call(@current_account)
        view :my_flocks, locals: { flocks:, current_account: @current_account }
      end

      # GET and POST /flock/create
      routing.is 'create' do
        routing.get do
          view :create_flock, locals: { current_account: @current_account }
        end

        routing.post do
          unless @current_account&.logged_in?
            flash[:error] = '請先登入來創建新資源'
            routing.redirect '/auth/login'
          end

          destination_url = routing.params['destination_url']
          new_flock = FlocksServices::CreateFlock.new(App.config).call(
            destination_url:,
            current_account: @current_account
          )

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