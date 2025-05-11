# frozen_string_literal: true

require 'roda'
require_relative 'app'

module Flocks
  # Web controller for Flocks API
  class App < Roda
    route('auth') do |routing|
      @login_route = '/auth/login'

      routing.is 'login' do
        # GET /auth/login
        routing.get do
          view :login
        end

        # POST /auth/login
        routing.post do
          account = AuthenticateAccount.new(App.config).call(
            email: routing.params['email'],
            password: routing.params['password']
          )

          session[:current_account] = account
          puts(session[:current_account])
          flash[:notice] = 'Welcome back to Flocks!'
          routing.redirect '/'
        rescue StandardError
          flash.now[:error] = 'Email and password did not match our records'
          response.status = 400
          view :login
        end
      end

      routing.is 'register' do
        # GET /auth/register
        routing.get do
          view :register
        end

        # POST /auth/register
        routing.post do
          if routing.params['password'] != routing.params['password_confirm']
            flash[:error] = 'Passwords do not match'
            routing.redirect '/auth/register'
          end

          # create account
          begin
            CreateAccount.new(App.config).call(
              email: routing.params['email'],
              password: routing.params['password']
            )

            flash[:notice] = 'Account created! Please login'
            routing.redirect '/auth/login'
          rescue StandardError => e
            flash[:error] = e.message
            routing.redirect '/auth/register'
          end
        end
      end

      routing.on 'logout' do
        routing.get do
          session[:current_account] = nil
          routing.redirect @login_route
        end
      end
    end
  end
end
