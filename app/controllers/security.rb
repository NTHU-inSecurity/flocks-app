# frozen_string_literal: true

require_relative './app'
require 'roda'

require 'rack/ssl-enforcer'
require 'secure_headers'

module Flocks
  # Configuration for the API
  class App < Roda
    plugin :environments
    plugin :multi_route

    FONT_SRC = %w[
      https://cdn.jsdelivr.net
      https://fonts.googleapis.com
      https://fonts.gstatic.com
    ].freeze

    SCRIPT_SRC = %w[
      https://cdn.jsdelivr.net
      https://cdnjs.cloudflare.com
      https://unpkg.com
      http://localhost:3000/faye/faye.js
    ].freeze

    STYLE_SRC = %w[
      https://bootswatch.com
      https://cdn.jsdelivr.net
      https://cdnjs.cloudflare.com
      https://unpkg.com
      https://fonts.googleapis.com
      https://maps.gstatic.com
    ].freeze

    configure :production do
      use Rack::SslEnforcer, hsts: true
    end

    use SecureHeaders::Middleware

    SecureHeaders::Configuration.default do |config|
      config.cookies = {
        secure: true,
        httponly: true,
        samesite: { lax: true }
      }

      config.x_frame_options = 'DENY'
      config.x_content_type_options = 'nosniff'
      config.x_xss_protection = '1'
      config.x_permitted_cross_domain_policies = 'none'
      config.referrer_policy = 'origin-when-cross-origin'

      # Because of never-ending resource problem for map
      # Unsafe CSP
      config.csp = {
        report_only: false,
        preserve_schemes: true,
        default_src: %w[* data: blob:],
        connect_src: %w[* data: blob:],
        script_src: %w[* 'unsafe-inline' 'unsafe-eval' data: blob:],
        script_src_attr: %w[* 'unsafe-inline' 'unsafe-eval' data: blob:],
        script_src_elem: %w[* 'unsafe-inline' 'unsafe-eval' data: blob:],
        style_src: %w[* 'unsafe-inline' data: blob:] + STYLE_SRC,
        img_src: %w[* data: blob:],
        font_src: %w[* data: blob:] + FONT_SRC,
        frame_ancestors: %w[*],
        object_src: %w[*],
        form_action: %w[*],
        report_uri: %w[]
      }
    end

    route('security') do |routing|
      routing.post 'report_csp_violation' do
        App.logger.warn "CSP VIOLATION: #{request.body.read}"
      end
    end
  end
end
