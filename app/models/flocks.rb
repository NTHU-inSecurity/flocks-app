# frozen_string_literal: true

require_relative 'flock'

module Flocks
  # Behaviors of the currently logged in account
  class Flocks
    attr_reader :all

    def initialize(flocks_list)
      @all = flocks_list.map do |flock|
        Flock.new(flock)
      end
    end
  end
end
