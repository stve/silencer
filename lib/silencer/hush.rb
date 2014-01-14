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
      (@routes[env['REQUEST_METHOD']] || @silence).any? { |s| s === env['PATH_INFO'] }
    end

  end
end
