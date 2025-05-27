# frozen_string_literal: true

require_relative 'form_base'

module Flocks
  module Form
    # Form object for deleting a flock
    # Validates flock ID and optional confirmation
    class DeleteFlock < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/delete_flock.yml')

      params do
        required(:flock_id).filled(:string)
        optional(:confirm).maybe(:bool)
        optional(:confirmation_text).maybe(:string)
      end

      rule(:flock_id) do
        # Validate UUID format if your flock IDs are UUIDs
        uuid_pattern = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
        key.failure('invalid_format') unless value.match?(uuid_pattern)
      end

      rule(:confirmation_text) do
        if values[:confirmation_text] && values[:confirmation_text].downcase != 'delete'
          key.failure('confirmation_mismatch')
        end
      end

      rule(:confirm) do
        key.failure('confirmation_required') if values[:confirm] == false
      end
    end
  end
end
