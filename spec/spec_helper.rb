unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_group 'Silencer', 'lib/silencer'
    add_group 'Specs', 'spec'
  end
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rack'
require 'rails'
require 'silencer'
require 'rspec'