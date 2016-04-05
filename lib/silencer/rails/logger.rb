require 'silencer/hush'
require 'silencer/methods'
require 'silencer/util'

module Silencer
  # rubocop:disable Style/ConstantName
  RailsLogger = begin
    if Silencer::Environment.rails2?
      require 'rails/rack/log_tailer'
      ::Rails::Rack::LogTailer
    else
      require 'rails/rack/logger'
      ::Rails::Rack::Logger
    end
  end

  module Rails
    class Logger < RailsLogger
      include Silencer::Hush
      include Silencer::Methods
      include Silencer::Util

      def initialize(app, *args)
        opts     = extract_options!(args)
        @silence = wrap(opts.delete(:silence))
        @routes  = define_routes(@silence, opts)

        if normalized_args = normalize(args) # rubocop:disable Lint/AssignmentInCondition
          super(app, normalized_args)
        else
          super(app)
        end
      end

      def call(env)
        if silence_request?(env)
          quiet do
            super
          end
        else
          super
        end
      end

      private

      def quiet(&block)
        if ::Rails.logger.respond_to?(:silence)
          quiet_with_silence(&block)
        else
          quiet_with_log_level(&block)
        end
      end

      # This is threadsafe in Rails 4.2.6+
      def quiet_with_silence
        ::Rails.logger.silence do
          yield
        end
      end

      # This is not threadsafe
      def quiet_with_log_level
        old_logger_level     = ::Rails.logger.level
        ::Rails.logger.level = ::Logger::ERROR

        yield
      ensure
        # Return back to previous logging level
        ::Rails.logger.level = old_logger_level
      end

      def normalize(args)
        case args.size
        when 0 then nil
        when 1 then args.shift
        else args
        end
      end
    end
  end
end
