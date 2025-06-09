# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Web Login Auth Routes' do
  include Rack::Test::Methods

  def app
    Flocks::App
  end

  before do
    @credentials = { 'username' => 'alice.wu', 'password' => 'Str0ngP@ssword!' }
    @mal_credentials = { 'username' => 'alice.wu', 'password' => 'incorrect123' }
    @login_route = '/auth/login'
    @home_route = '/'
    @fixture_path = 'spec/fixtures/auth_account.json'
  end

  after do
    WebMock.reset!
  end

  describe 'GET /auth/login' do
    it 'should load the login form' do
      get @login_route
      _(last_response.status).must_equal 200
      _(last_response.body).must_include 'form'
    end
  end

  describe 'POST /auth/login' do
    it 'HAPPY: should login successfully with valid credentials' do
      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with { |req|
               body = JSON.parse(req.body)
               body['data'] == @credentials && body.key?('signature')
             }
             .to_return(body: File.read(@fixture_path),
                        headers: { 'content-type' => 'application/json' })

      post @login_route, @credentials

      follow_redirect!
      _(last_request.path).must_equal @home_route
      _(last_response.body).must_include 'Welcome back alice.wu'
    end

    # it 'SAD: should reject bad credentials with 401 and show login again' do
    #   WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
    #          .with { |req|
    #            body = JSON.parse(req.body)
    #            body['data'] == @mal_credentials && body.key?('signature')
    #          }
    #          .to_return(status: 403)

    #   post @login_route, @mal_credentials

    #   _(last_response.status).must_equal 401
    #   _(last_response.body).must_include 'Username and password did not match'
    # end

    it 'SAD: should handle API server failure with flash message and redirect' do
      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with { |req|
               body = JSON.parse(req.body)
               body['data'] == @credentials && body.key?('signature')
             }
             .to_return(status: 500)

      post @login_route, @credentials

      follow_redirect!
      _(last_request.path).must_equal @login_route
      _(last_response.body).must_include 'Our servers are not responding'
    end

    it 'SAD: should handle missing credentials' do
      post @login_route, {}

      follow_redirect!
      _(last_request.path).must_equal @login_route
      _(last_response.body).must_include 'Please enter both username and password'
    end
  end
end
