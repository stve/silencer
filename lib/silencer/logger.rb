# frozen_string_literal: true

require 'silencer/rack/logger'
require 'silencer/environment'

module Silencer
  if Silencer::Environment.rails?
    require 'silencer/rails/logger'
    Logger = Silencer::Rails::Logger
  else
    Logger = Silencer::Rack::Logger
  end
end
