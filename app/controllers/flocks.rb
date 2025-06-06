# frozen_string_literal: true

require 'roda'
require_relative './app'

module Flocks
  # Web controller for Flocks APP (flock routes)
  class App < Roda 
    route('flock') do |routing| 

      routing.redirect '/auth/login' unless @current_account.logged_in?
      @flocks_route = '/flock/all'

      # GET /flock/all
      routing.is 'all' do
        flocks_info = FlocksServices::GetFlocks.new(App.config).call(@current_account)
        flocks = Flocks.new(flocks_info)

        view :flocks, locals: { flocks: flocks, current_account: @current_account }
      end

      # GET /flock/share/[ID]
      routing.on 'share', String do |flock_id|
        flock_data = FlocksServices::GetFlock.new(App.config).call(current_account: @current_account,
                                                                   flock_id: flock_id)
        flock = Flock.new(flock_data)                                                           
                                                                   
        view :share_flocks, locals: { flock: flock, current_account: @current_account }
      rescue StandardError => e
        App.logger.error "#{e.inspect}\n#{e.backtrace}"
        flash[:error] = 'Flock not found'
        routing.redirect @flocks_route
      end

      # POST /flock/join/[ID]
      routing.on 'join', String do |flock_id|
        routing.post do
          FlocksServices::JoinFlock.new(App.config).call(
            current_account: @current_account,
            flock_id: flock_id
          )
          flash[:notice] = 'You have successfully joined the flock!'
          routing.redirect @flocks_route
        rescue StandardError => e
          App.logger.error "#{e.inspect}\n#{e.backtrace}"
          flash[:error] = "Couldn't join the flock"
          routing.redirect @flocks_route
        end
      end

      routing.is 'create' do
        # GET /flock/create
        routing.get do
          view :create_flock, locals: { current_account: @current_account }
        end

        # POST /flock/create
        routing.post do
          form = Form::NewFlock.new.call(routing.params)

          if form.failure?
            flash[:error] = Form.message_values(form)
            routing.halt
          end

          FlocksServices::CreateFlock.new(App.config).call(
            destination_url: form[:destination_url], 
            current_account: @current_account
          )

          flash[:notice] = 'Flock created successfully'
          routing.redirect '/flock/all'
        rescue StandardError => e
          App.logger.error "ERROR CREATING FLOCK: #{e.inspect}"
          flash[:error] = 'Could not create flock'
        ensure
          routing.redirect @flocks_route
        end
      end

      routing.on String, 'delete' do |flock_id|
        # GET /flock/[ID]/delete
        routing.get do
          view :delete_flock, locals: { current_account: @current_account, flock_id: }
        end

        # POST /flock/[ID]/delete
        routing.post do
          FlocksServices::DeleteFlock.new(App.config).call(flock_id:, current_account: @current_account)

          flash[:notice] = 'Flock deleted successfully'
          routing.redirect @flocks_route
        rescue StandardError => e
          App.logger.error "ERROR DELETING FLOCK: #{e.inspect}"
          flash[:error] = 'Could not delete flock'
        ensure
          routing.redirect @flocks_route
        end
      end

      # GET and POST /flock/[ID]/edit
      routing.on String, 'edit' do |flock_id|
        routing.get do
          view :edit_flock, locals: { current_account: @current_account, flock_id: }
        end

        routing.post do
          form = Form::NewFlock.new.call(routing.params)

          if form.failure?
            flash[:error] = Form.message_values(form)
            routing.halt
          end

          FlocksServices::UpdateFlock.new(App.config).call(
            flock_id:, 
            destination_url: form[:destination_url],
            current_account: @current_account
          )

          flash[:notice] = 'Meeting place updated successfully'
          routing.redirect @flocks_route
        rescue StandardError => e
          App.logger.error "ERROR UPDATING FLOCK: #{e.inspect}"
          flash[:error] = 'Could not update meeting place'
        ensure
          routing.redirect @flocks_route
        end
      end
    end
  end
end
