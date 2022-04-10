# frozen_string_literal: true

require 'rails/rack/logger'
require 'silencer/hush'
require 'silencer/methods'
require 'silencer/util'

module Silencer
  module Rails
    class Logger < ::Rails::Rack::Logger
      include Silencer::Hush
      include Silencer::Methods
      include Silencer::Util

      def initialize(app, *args)
        opts     = extract_options!(args)
        @silence = wrap(opts.delete(:silence))
        @routes  = define_routes(@silence, opts)

        @enable_header = opts.delete(:enable_header) { true }

        normalized_args = normalize(args)
        if normalized_args
          super(app, normalized_args)
        else
          super(app)
        end
      end

      def call(env)
        if silence_request?(env, enable_header: @enable_header)
          quiet do
            super
          end
        else
          super
        end
      end

      private

      def quiet(&block)
        if ::Rails.logger.respond_to?(:silence) && ::Rails.logger.method(:silence).owner != ::Kernel
          quiet_with_silence(&block)
        else
          quiet_with_log_level(&block)
        end
      end

      # This is threadsafe in Rails 4.2.6+
      def quiet_with_silence(&block)
        ::Rails.logger.silence(&block)
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
