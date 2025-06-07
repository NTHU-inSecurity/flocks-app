# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Service Objects' do
  before do
    @credentials = { username: 'alice.wu', password: 'Str0ngP@ssword!' }
    @mal_credentials = { username: 'alice.wu', password: 'incorrect123' }
    @api_account = { 'username' => 'alice.wu', 'email' => 'alice.wu@dev.com' }
  end

  after do
    WebMock.reset!
  end

  describe 'Find authenticated account' do
    it 'HAPPY: should find an authenticated account' do
      auth_account_file = 'spec/fixtures/auth_account.json'
      auth_return_json = File.read(auth_account_file)

      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with { |req|
               body = JSON.parse(req.body)
               body['data'] == @credentials.transform_keys(&:to_s) && body.key?('signature')
             }
             .to_return(body: auth_return_json,
                        headers: { 'content-type' => 'application/json' })

      auth = Flocks::AuthenticateAccount.new(Flocks::App.config).call(**@credentials)

      account = auth[:account]
      _(account).wont_be_nil
      _(account['attributes']['username']).must_equal @api_account['username']
      _(account['attributes']['email']).must_equal @api_account['email']
    end

    it 'BAD: should not find a false authenticated account' do
      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with { |req|
               body = JSON.parse(req.body)
               body['data'] == @mal_credentials.transform_keys(&:to_s) && body.key?('signature')
             }
             .to_return(status: 403)

      _(proc {
        Flocks::AuthenticateAccount.new(Flocks::App.config).call(**@mal_credentials)
      }).must_raise Flocks::AuthenticateAccount::UnauthorizedError
    end
  end
end
