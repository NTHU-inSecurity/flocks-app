# frozen_string_literal: true

require 'roda'
require_relative './app'

module Flocks
  # Web controller for Flocks API
  class App < Roda
    route('map') do |routing|
      routing.on do
        view :map
      end
    end
  end
end