# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Service Objects' do
  before do
    @account_details = {
      username: 'alice.wu',
      email: 'alice.wu@dev.com',
      password: 'Str0ngP@ssword!'
    }
  end

  after do
    WebMock.reset!
  end

  describe 'Create new account' do
    it 'HAPPY: should create a valid account' do
      account_return_json = File.read('spec/fixtures/auth_account.json')

      WebMock.stub_request(:post, "#{Flocks::App.config.API_URL}/accounts/")
             .with(body: @account_details)
             .to_return(status: 201, body: account_return_json,
                        headers: { 'content-type' => 'application/json' })

      Flocks::CreateAccount.new(Flocks::App.config).call(**@account_details)
    end

    it 'BAD: should raise error if account creation fails' do
      WebMock.stub_request(:post, "#{Flocks::App.config.API_URL}/accounts/")
             .with(body: @account_details)
             .to_return(status: 422)

      _(proc {
        Flocks::CreateAccount.new(Flocks::App.config).call(**@account_details)
      }).must_raise Flocks::CreateAccount::InvalidAccount
    end
  end
end