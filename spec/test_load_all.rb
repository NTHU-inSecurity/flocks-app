# frozen_string_literal: true

require_relative '../require_app'
require_app

require 'rack/test'
include Rack::Test::Methods # rubocop:disable Style/MixinUsage

def app
  Flocks::App.freeze.app
end

describe 'Flocks App' do
  describe 'Homepage and login page' do
    it 'should load the homepage successfully' do
      get '/'
      _(last_response.status).must_equal 200
      _(last_response.body).must_include 'Welcome to Flocks'
    end

    it 'should load the login page successfully' do
      get '/auth/login'
      _(last_response.status).must_equal 200
      _(last_response.body).must_include 'Login'
    end
  end
end
