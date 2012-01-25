require 'rails/rack/logger'

module Silencer
  class Logger < Rails::Rack::Logger
    def initialize(app, opts = {})
      @app = app
      @opts = opts
      @opts[:silence] ||= []
    end

    def call(env)
      if silence_request?(env)
        Rails.logger.silence do
          @app.call(env)
        end
      else
        super(env)
      end
    end

    private

    def silence_request?(env)
      silent_header?(env) || silent_request_path?(env) || silent_request_match?(env)
    end

    def silent_header?(env)
      env['X-SILENCE-LOGGER']
    end

    def silent_request_path?(env)
      @opts[:silence].include?(env['PATH_INFO'])
    end

    def silent_request_match?(env)
      @opts[:silence].select {|s| s.kind_of?(Regexp) }.any? { |s| s =~ env['PATH_INFO']}
    end
  end
end
