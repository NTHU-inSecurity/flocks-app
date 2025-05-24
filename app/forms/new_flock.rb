# frozen_string_literal: true

require_relative 'form_base'

module Flocks
  module Form
    # Form object for creating a new flock with destination URL
    # Validates Google Maps URLs for meeting locations
    class NewFlock < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_flock.yml')

      params do
        required(:destination_url).filled(format?: URI::DEFAULT_PARSER.make_regexp)
      end

      rule(:destination_url) do
        key.failure('google_maps_url') unless value&.include?('maps.google.com') || value&.include?('maps.app.goo.gl')
      end
    end
  end
end
