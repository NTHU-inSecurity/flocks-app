# frozen_string_literal: true

require_relative 'form_base'

module Flocks
  module Form
    # Form object for creating a new flock with destination URL
    # Validates Google Maps URLs for meeting locations
    class NewFlock < Dry::Validation::Contract
      FAIL_MSG = 'Please enter a valid destination URL (Google Maps URL)'

      params do
        required(:destination_url).value(:string)
      end

      rule(:destination_url) do
        key.failure(FAIL_MSG) unless value.match?(GOOGLE_MAPS_URL_REGEX)
      end
    end
  end
end
