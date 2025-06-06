# frozen_string_literal: true

require_relative 'bird'

module Flocks
  # Birds object representing a collection of birds (users in flocks)
  class Birds
    attr_reader :all

    def initialize(birds_list)
      @all = birds_list.map do |bird|
        Bird.new(bird)
      end
    end
  end
end
