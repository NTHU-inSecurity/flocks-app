# frozen_string_literal: true

require 'dry-validation'

module Flocks
  # Form helpers
  module Form
    USERNAME_REGEX = /^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*$/
    EMAIL_REGEX = /@/

    # Google Maps URL patterns
    GOOGLE_MAPS_URL_REGEX = %r{^https://(maps\.google\.com|maps\.app\.goo\.gl)/.+$}

    # Coordinate validations
    LATITUDE_RANGE = (-90.0..90.0)
    LONGITUDE_RANGE = (-180.0..180.0)

    def self.validation_errors(validation)
      validation.errors.to_h.map { |k, v| [k, v].join(' ') }.join('; ')
    end

    def self.message_values(validation)
      validation.errors.to_h.values.join('; ')
    end

    def self.valid_coordinates?(latitude, longitude)
      return false unless latitude && longitude

      LATITUDE_RANGE.cover?(latitude) && LONGITUDE_RANGE.cover?(longitude)
    end

    def self.valid_google_maps_url?(url)
      return false unless url

      url.match?(GOOGLE_MAPS_URL_REGEX)
    end
  end
end
