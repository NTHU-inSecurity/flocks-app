# frozen_string_literal: true

module Flocks
  # Behaviors of a flock (group) from API response
  # Represents a group with destination and members (birds)
  class Flock
    attr_reader :id, :destination_url, :creator, :birds

    def initialize(flock_info)
      process_attributes(flock_info['attributes']) if flock_info['attributes']
      process_relationships(flock_info['relationships']) if flock_info['relationships']
      process_included(flock_info['included']) if flock_info['included']
    end

    def creator_username
      @creator&.username
    end

    def birds_count
      @birds&.size || 0
    end

    def birds?
      birds_count.positive?
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @destination_url = attributes['destination_url']
    end

    def process_relationships(relationships)
      @creator = Account.new(relationships['creator']) if relationships['creator']
      @birds = process_birds(relationships['birds']) if relationships['birds']
    end

    def process_birds(birds_data)
      return [] unless birds_data.is_a?(Array)

      birds_data.map { |bird_data| Bird.new(bird_data) }
    end

    def process_included(included_data)
      # Handle any additional included data from API response
      # This can be extended based on your API response structure
    end
  end
end
