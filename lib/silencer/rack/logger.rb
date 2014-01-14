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
