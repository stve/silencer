module Silencer
  module Hush
    private

    def silence_request?(env)
      (silent_header?(env) || silent_path?(env))
    end

    def silent_header?(env)
      env['HTTP_X_SILENCE_LOGGER']
    end

    def silent_path?(env)
      (@routes[env['REQUEST_METHOD']] || @silence).any? do |rule|
        case rule
        when String, Integer
          rule.to_s == env['PATH_INFO']
        when Regexp
          rule =~ env['PATH_INFO']
        else
          false
        end
      end
    end
  end
end
