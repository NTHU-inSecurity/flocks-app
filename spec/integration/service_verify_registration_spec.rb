# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Service Objects' do
  before do
    @registration_data = {
      username: 'alice.wu',
      email: 'alice.wu@dev.com',
      password: 'Str0ngP@ssword!'
    }

    @token = 'fake_registration_token'
    @expected_url = "#{Flocks::App.config.APP_URL}/auth/register/#{@token}"
  end

  after do
    WebMock.reset!
  end

  describe 'Verify registration process' do
    it 'HAPPY: should verify a registration and return parsed response' do
      expected_response = { 'message' => 'Verification sent' }

      # Stub SecureMessage.encrypt to return a fake token
      SecureMessage.stub :encrypt, @token do
        WebMock.stub_request(:post, "#{Flocks::App.config.API_URL}/auth/register")
               .with(
                 body: @registration_data.merge('verification_url' => @expected_url)
               )
               .to_return(status: 202,
                          body: expected_response.to_json,
                          headers: { 'content-type' => 'application/json' })

        result = Flocks::VerifyRegistration.new(Flocks::App.config).call(@registration_data.dup)

        _(result).must_equal expected_response
      end
    end

    it 'BAD: should raise VerificationError if server rejects registration' do
      SecureMessage.stub :encrypt, @token do
        WebMock.stub_request(:post, "#{Flocks::App.config.API_URL}/auth/register")
               .with(
                 body: @registration_data.merge('verification_url' => @expected_url)
               )
               .to_return(status: 400)

        _(proc {
          Flocks::VerifyRegistration.new(Flocks::App.config).call(@registration_data.dup)
        }).must_raise Flocks::VerifyRegistration::VerificationError
      end
    end
  end
end