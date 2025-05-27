# frozen_string_literal: true

module Flocks
  # Behaviors of a bird (user in flock) from API response
  # Represents a user's participation in a flock with location and status
  class Bird
    attr_reader :id, :message, :latitude, :longitude, :estimated_time, :account, :flock

    def initialize(bird_info)
      process_attributes(bird_info['attributes']) if bird_info['attributes']
      process_relationships(bird_info['relationships']) if bird_info['relationships']
      process_included(bird_info['included']) if bird_info['included']
    end

    def username
      @account&.username
    end

    def location?
      !@latitude.nil? && !@longitude.nil?
    end

    def estimated_time_minutes
      return nil unless @estimated_time

      (@estimated_time / 60.0).round
    end

    def estimated_time_formatted
      return 'Unknown' unless @estimated_time

      minutes = estimated_time_minutes
      return "#{minutes} min" if minutes < 60

      hours = minutes / 60
      remaining_minutes = minutes % 60
      "#{hours}h #{remaining_minutes}m"
    end

    def location_coordinates
      return nil unless location?

      { latitude: @latitude, longitude: @longitude }
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @message = attributes['message']
      @latitude = attributes['latitude']
      @longitude = attributes['longitude']
      @estimated_time = attributes['estimated_time']
    end

    def process_relationships(relationships)
      @account = Account.new(relationships['account']) if relationships['account']
      @flock = Flock.new(relationships['flock']) if relationships['flock']
    end

    def process_included(included_data)
      # Handle any additional included data from API response
      # This can be extended based on your API response structure
      @flock = Flock.new(included_data['flock']) if included_data['flock']

      return unless included_data['account']

      @account = Account.new(included_data['account'])
    end
  end
end
