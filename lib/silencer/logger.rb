require 'rails/rack/logger'

module Silencer
  class Logger < Rails::Rack::Logger
    def initialize(app, opts = {})
      @app = app
      @opts = opts
      @opts[:silence] ||= []
    end

    def call(env)
      silence_request = env['X-SILENCE-LOGGER']
      silence_request ||= @opts[:silence].include?(env['PATH_INFO'])
      silence_request ||= @opts[:silence].select {|s| s.kind_of?(Regexp) }.any? { |s| s =~ env['PATH_INFO']}

      if silence_request
        Rails.logger.silence do
          @app.call(env)
        end
      else
        super(env)
      end
    end
  end
end
