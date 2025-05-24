# frozen_string_literal: true

require_relative 'form_base'

module Flocks
  module Form
    # Form object for updating bird information in a flock
    # Validates message updates, location changes, and estimated time adjustments
    class UpdateBird < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/update_flock.yml')

      params do
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

      # Ensure at least one field is provided for update
      rule do
        base.failure('update_required') unless values.values_at(:message, :latitude, :longitude, :estimated_time).any?
      end
    end
  end
end
