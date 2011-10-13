require 'simplecov'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rack'
require 'rails'
require 'silencer'
require 'rspec'