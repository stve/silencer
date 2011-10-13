require 'rails/rack/logger'

module Silencer
  class Logger < Rails::Rack::Logger
    def initialize(app, opts = {})
      @app = app
      @opts = opts
      @opts[:silence] ||= []
    end

    def call(env)
      if env['X-SILENCE-LOGGER'] || @opts[:silence].include?(env['PATH_INFO'])
        Rails.logger.silence do
          @app.call(env)
        end
      else
        super(env)
      end
    end
  end
end
