module Silencer
  module Environment

    RAILS_2_3 = %r{^2.3}

    def rails?
      defined?(::Rails)
    end

    def rails_version
      return unless rails?
      ::Rails::VERSION::STRING
    end

    def rails2?
      rails_version =~ RAILS_2_3
    end

    module_function :rails?, :rails2?, :rails_version

  end
end
