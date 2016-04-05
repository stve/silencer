require 'silencer/rack/logger'
require 'silencer/environment'

module Silencer
  # rubocop:disable Style/ConstantName
  Logger = begin
    if Silencer::Environment.rails?
      require 'silencer/rails/logger'
      Silencer::Rails::Logger
    else
      Silencer::Rack::Logger
    end
  end
end
