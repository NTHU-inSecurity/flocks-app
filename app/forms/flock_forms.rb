# frozen_string_literal: true

require_relative 'form_base'

module Flocks
  module Form
    # Form for creating a new flock
    class NewFlock < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/flock.yml')

      params do
        required(:destination_url).filled(format?: URI::DEFAULT_PARSER.make_regexp)
      end

      rule(:destination_url) do
        unless value&.include?('maps.google.com') || value&.include?('maps.app.goo.gl')
          key.failure('must be a valid Google Maps URL')
        end
      end
    end

    # Form for joining a flock (adding a bird)
    class JoinFlock < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/flock.yml')

      params do
        required(:username).filled(format?: USERNAME_REGEX, min_size?: 2)
        optional(:message).maybe(:string, max_size?: 200)
        optional(:latitude).maybe(:float)
        optional(:longitude).maybe(:float)
        optional(:estimated_time).maybe(:integer, gteq?: 0)
      end

      rule(:latitude, :longitude) do
        if values[:latitude] && !values[:longitude]
          key(:longitude).failure('must be provided when latitude is given')
        elsif values[:longitude] && !values[:latitude]
          key(:latitude).failure('must be provided when longitude is given')
        end
      end

      rule(:latitude) do
        key.failure('must be between -90 and 90 degrees') if value && (value < -90 || value > 90)
      end

      rule(:longitude) do
        key.failure('must be between -180 and 180 degrees') if value && (value < -180 || value > 180)
      end
    end

    # Form for updating bird information
    class UpdateBird < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/flock.yml')

      params do
        optional(:message).maybe(:string, max_size?: 200)
        optional(:latitude).maybe(:float)
        optional(:longitude).maybe(:float)
        optional(:estimated_time).maybe(:integer, gteq?: 0)
      end

      rule(:latitude, :longitude) do
        if values[:latitude] && !values[:longitude]
          key(:longitude).failure('must be provided when latitude is given')
        elsif values[:longitude] && !values[:latitude]
          key(:latitude).failure('must be provided when longitude is given')
        end
      end

      rule(:latitude) do
        key.failure('must be between -90 and 90 degrees') if value && (value < -90 || value > 90)
      end

      rule(:longitude) do
        key.failure('must be between -180 and 180 degrees') if value && (value < -180 || value > 180)
      end

      # Ensure at least one field is provided for update
      rule do
        unless values.values_at(:message, :latitude, :longitude, :estimated_time).any?
          base.failure('at least one field must be provided for update')
        end
      end
    end
  end
end
