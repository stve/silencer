require 'rails/rack/logger'

module Silencer
  class Logger < Rails::Rack::Logger
    def initialize(app, *taggers)
      @app = app
      opts = taggers.extract_options!
      @taggers = taggers.flatten
      @silence = wrap(opts[:silence])
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
      env['HTTP_X_SILENCE_LOGGER'] || @silence.any? { |s| s === env['PATH_INFO'] }
    end

    def wrap(object)
      if object.nil?
        []
      elsif object.respond_to?(:to_ary)
        object.to_ary || [object]
      else
        [object]
      end
    end
  end
end
