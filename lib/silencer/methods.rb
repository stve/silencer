module Silencer
  module Methods
    METHODS = %i[options get head post put delete trace connect patch]

    def define_routes(silence_paths, opts)
      METHODS.each_with_object({}) do |method, routes|
        routes[method.to_s.upcase] = wrap(opts.delete(method)) + silence_paths
        routes
      end
    end
  end
end
