require 'rack/logger'
require 'silencer/hush'
require 'silencer/methods'
require 'silencer/util'

module Silencer
  module Rack
    class Logger < ::Rack::Logger
      include Silencer::Hush
      include Silencer::Methods
      include Silencer::Util

      def initialize(app, *args)
        opts     = extract_options!(args)
        @silence = wrap(opts.delete(:silence))
        @routes  = define_routes(@silence, opts)

        super(app, *args)
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
