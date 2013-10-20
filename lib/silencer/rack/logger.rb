require 'rack/logger'
require 'silencer/util'
require 'silencer/hush'

module Silencer
  module Rack
    class Logger < ::Rack::Logger
      include Silencer::Util
      include Silencer::Hush

      def initialize(app, *args)
        opts     = extract_options!(args)
        @silence = wrap(opts.delete(:silence))

        super app, *args
      end

      def call(env)
        logger       = ::Logger.new(env['rack.errors'])
        logger.level = (silence_request?(env) ? ::Logger::ERROR : @level)

        env['rack.logger'] = logger
        @app.call(env)
      end
    end
  end
end
