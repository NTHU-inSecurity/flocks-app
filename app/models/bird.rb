# frozen_string_literal: true

module Flocks
  # Behaviors of a bird (user in flock) from API response
  # Represents a user's participation in a flock with location and status
  class Bird
    attr_reader :id, :message, :latitude, :longitude, :estimated_time, :flock, :account_name

    def initialize(bird_info)
      process_attributes(bird_info['data']['attributes'])
      process_included(bird_info['included'])
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @message = attributes['message']
      @latitude = attributes['latitude']
      @longitude = attributes['longitude']
      @estimated_time = attributes['estimated_time']
    end

    def process_included(included)
      @flock = Flock.new(included['flock'])
      @account_name = included['account']['attributes']['username']
    end
  end
end
