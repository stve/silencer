require 'rails/rack/logger'
require 'active_support/core_ext/array/wrap'

module Silencer
  class Logger < Rails::Rack::Logger
    def initialize(app, taggers = nil, opts = {})
      @app, @taggers = app, taggers || []
      @silence = Array.wrap(opts[:silence])
    end

    def call(env)
      old_logger_level   = Rails.logger.level
      Rails.logger.level = ::Logger::ERROR if silence_request?(env)

      super
    ensure
      # Return back to previous logging level
      Rails.logger.level = old_logger_level
    end

    private

    def silence_request?(env)
      env['X-SILENCE-LOGGER'] || @silence.any? { |s| s === env['PATH_INFO'] }
    end
  end
end
