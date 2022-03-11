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

        @enable_header = opts.delete(:enable_header) { true }

        super(app, *args)
      end

      def call(env)
        if silence_request?(env, enable_header: @enable_header)
          quiet(env) do
            super
          end
        else
          super
        end
      end

      private

      def quiet(env)
        old_logger = env['rack.logger']
        logger = ::Logger.new(env['rack.errors'])
        logger.level = ::Logger::ERROR

        env['rack.logger'] = logger
        yield
      ensure
        env['rack.logger'] = old_logger
      end
    end
  end
end
