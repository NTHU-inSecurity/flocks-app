# frozen_string_literal: true

require 'roda'
require_relative 'app'

module Flocks
  class App < Roda
    route('flock') do |routing|
      # GET /flock/all
      routing.is 'all' do
        flocks = FlocksServices::GetFlocks.new(App.config).call(@current_account['username'])
        view :flocks, locals: { flocks:, current_account: @current_account }
      end

      # create：GET /flock/my - current_account flocks
      routing.is 'my' do
        # check if the user is logged in
        unless @current_account&.logged_in?
          flash[:error] = 'please login first'
          routing.redirect '/auth/login'
        end
        # user flocks
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
          # check if the user is logged in
          unless @current_account&.logged_in?
            flash[:error] = '請先登入來創建新資源'
            routing.redirect '/auth/login'
          end

          destination_url = routing.params['destination_url']

          # use auth token to create a new flock
          new_flock = FlocksServices::CreateFlock.new(App.config)
                                                 .call(
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
