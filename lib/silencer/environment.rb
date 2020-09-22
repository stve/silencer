module Silencer
  module Environment
    RAILS_4 = /^4/
    RAILS_5 = /^5/

    module_function

    def rails?
      defined?(::Rails) && ::Rails.logger.present?
    end

    def rails_version
      return unless rails?

      ::Rails::VERSION::STRING
    end

    def rails4?
      rails_version =~ RAILS_4
    end

    def rails5?
      rails_version =~ RAILS_5
    end

    def tagged_logger?
      rails4? || rails5?
    end
  end
end
