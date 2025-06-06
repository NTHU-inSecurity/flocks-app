# frozen_string_literal: true

require_relative 'flock'

module Flocks
  # Flocks object representing a collection of flocks
  class Flocks
    attr_reader :all

    def initialize(flocks_list)
      @all = flocks_list.map do |flock|
        Flock.new(flock)
      end
    end
  end
end
