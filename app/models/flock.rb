# frozen_string_literal: true

require 'ostruct'

module Flocks
  # Behaviors of a flock (group) from API response
  # Represents a group with destination and members (birds)
  class Flock
    attr_reader :id, :destination_url, :creator, :birds, :policies

    def initialize(flock_info)
      process_attributes(flock_info['attributes'])
      process_included(flock_info['included'])
      process_policies(flock_info['policies'])
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @destination_url = attributes['destination_url']
    end

    def process_included(included)
      return unless included

      @creator = Account.new(included['creator'])
      @birds = process_birds(relationships['birds'])
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end

    def process_birds(birds_data)
      return nil unless birds_data

      birds_data.map { |bird_data| Bird.new(bird_data) }
    end
  end
end
