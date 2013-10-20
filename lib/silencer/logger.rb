require 'silencer/environment'
require 'silencer/rack/logger'
require 'silencer/rails/logger' if Silencer::Environment.rails?

module Silencer
  Logger = if Silencer::Environment.rails?
    Silencer::Rails::Logger
  else
    Silencer::Rack::Logger
  end
end
