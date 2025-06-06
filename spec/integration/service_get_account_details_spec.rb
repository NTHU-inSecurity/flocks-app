# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Service Objects' do
  before do
    account_fixture = JSON.parse(File.read('spec/fixtures/get_account.json'))
    attributes = account_fixture['data']['attributes']

    @account_details = attributes['account']['attributes']
    @auth_token = attributes['auth_token']
    @expected_username = @account_details['username']

    @current_account = Minitest::Mock.new
    @current_account.expect :auth_token, @auth_token

    @fixture_json = account_fixture.to_json
  end

  after do
    WebMock.reset!
  end

  describe 'Get account details' do
    it 'HAPPY: should return a Flocks::Account instance with correct data' do
      WebMock.stub_request(:get, "#{Flocks::App.config.API_URL}/accounts/#{@expected_username}")
             .with(headers: { 'Authorization' => "Bearer #{@auth_token}" })
             .to_return(status: 200,
                        body: @fixture_json,
                        headers: { 'content-type' => 'application/json' })

      account = Flocks::GetAccountDetails
                .new(Flocks::App.config)
                .call(@current_account, @expected_username)
      _(account).must_be_kind_of Flocks::Account
      _(account.account_info['attributes']['username']).must_equal @account_details['username']
      _(account.account_info['attributes']['email']).must_equal @account_details['email']
    end

    it 'BAD: should raise error if unauthorized' do
      WebMock.stub_request(:get, "#{Flocks::App.config.API_URL}/accounts/#{@expected_username}")
             .with(headers: { 'Authorization' => "Bearer #{@auth_token}" })
             .to_return(status: 403)

      _(proc {
        Flocks::GetAccountDetails
          .new(Flocks::App.config)
          .call(@current_account, @expected_username)
      }).must_raise Flocks::GetAccountDetails::InvalidAccount
    end
  end
end
