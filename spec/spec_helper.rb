unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter '.bundle'
    add_group 'Silencer', 'lib/silencer'
    add_group 'Specs', 'spec'
  end
end

require 'rack'
require 'rails'
require 'silencer'
require 'rspec'
