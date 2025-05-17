# frozen_string_literal: true

require 'http'

module Flocks
  # Error for invalid credentials
  class UnauthorizedError < StandardError
    def initialize(msg = nil)
      super
      @credentials = msg
    end

    def message
      if @credentials && @credentials[:username]
        "Invalid Credentials for: #{@credentials[:username]}"
      else
        'Invalid Authorization Token'
      end
    end
  end

  # Find account and check password
  class AuthenticateAccount
    def self.call(credentials)
      if credentials[:auth_token]
        account = Account.first(auth_token: credentials[:auth_token])
        account || raise
      else
        account = Account.first(username: credentials[:username])
        account.password?(credentials[:password]) ? account : raise
      end
    rescue StandardError
      raise UnauthorizedError, credentials
    end
  end
end
