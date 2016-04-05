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
        @routes  = {
          'OPTIONS' => wrap(opts.delete(:options)) + @silence,
          'GET'     => wrap(opts.delete(:get)) + @silence,
          'HEAD'    => wrap(opts.delete(:head)) + @silence,
          'POST'    => wrap(opts.delete(:post)) + @silence,
          'PUT'     => wrap(opts.delete(:put)) + @silence,
          'DELETE'  => wrap(opts.delete(:delete)) + @silence,
          'TRACE'   => wrap(opts.delete(:trace)) + @silence,
          'CONNECT' => wrap(opts.delete(:connect)) + @silence,
          'PATCH'   => wrap(opts.delete(:patch)) + @silence,
        }

        if normalized_args = normalize(args)
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
          quiet_with_silence do
            block.call
          end
        else
          quiet_with_log_level do
            block.call
          end
        end
      end

      # This is threadsafe in Rails 4.2.6+
      def quiet_with_silence(&block)
        ::Rails.logger.silence do
          block.call
        end
      end

      # This is not threadsafe
      def quiet_with_log_level(&block)
        old_logger_level     = ::Rails.logger.level
        ::Rails.logger.level = ::Logger::ERROR
        block.call
      ensure
        # Return back to previous logging level
        ::Rails.logger.level = old_logger_level
      end

      def normalize(args)
        args = case args.size
        when 0 then nil
        when 1 then args.shift
        else args
        end
      end
    end
  end
end
