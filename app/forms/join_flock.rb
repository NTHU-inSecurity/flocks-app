# frozen_string_literal: true

require_relative 'form_base'

module Flocks
  module Form
    # Form object for joining a flock as a bird
    # Validates user information, location coordinates, and estimated arrival time
    class JoinFlock < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/join_flock.yml')

      params do
        required(:username).filled(format?: USERNAME_REGEX, min_size?: 2)
        optional(:message).maybe(:string, max_size?: 200)
        optional(:latitude).maybe(:float)
        optional(:longitude).maybe(:float)
        optional(:estimated_time).maybe(:integer, gteq?: 0)
      end

      rule(:latitude, :longitude) do
        if values[:latitude] && !values[:longitude]
          key(:longitude).failure('coordinates_required')
        elsif values[:longitude] && !values[:latitude]
          key(:latitude).failure('coordinates_required')
        end
      end

      rule(:latitude) do
        key.failure('latitude') if value && (value < -90 || value > 90)
      end

      rule(:longitude) do
        key.failure('longitude') if value && (value < -180 || value > 180)
      end
    end
  end
end
