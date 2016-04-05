module Silencer
  module Environment
    RAILS_2_3 = /^2.3/
    RAILS_3_2 = /^3.2/
    RAILS_4 = /^4/

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

    def rails3_2?
      rails_version =~ RAILS_3_2
    end

    def rails4?
      rails_version =~ RAILS_4
    end

    def tagged_logger?
      rails3_2? || rails4?
    end

    module_function :rails?, :rails2?, :rails_version, :rails3_2?
    module_function :rails4?, :tagged_logger?
  end
end
