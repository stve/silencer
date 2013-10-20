module Silencer
  RailsLogger = if Silencer::Environment.rails2?
    require 'rails/rack/log_tailer'
    ::Rails::Rack::LogTailer
  else
    require 'rails/rack/logger'
    ::Rails::Rack::Logger
  end

  module Rails
    class Logger < RailsLogger
      include Silencer::Util
      include Silencer::Hush

      def initialize(app, *args)
        opts     = extract_options!(args)
        @silence = wrap(opts.delete(:silence))

        super(app, args.flatten)
      end

      def call(env)
        old_logger_level     = ::Rails.logger.level
        ::Rails.logger.level = ::Logger::ERROR if silence_request?(env)

        super
      ensure
        # Return back to previous logging level
        ::Rails.logger.level = old_logger_level
      end
    end
  end
end
