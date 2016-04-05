unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_group 'Silencer', 'lib/silencer'
    add_group 'Specs', 'spec'
  end
end

require 'rack'
require 'rspec'

require 'logger'
require 'stringio'

io = StringIO.new

begin
  require 'rails'
  if Rails::VERSION::MAJOR >= 4
    ::Rails.logger = ::ActiveSupport::Logger.new(io)
  else
    ::Rails.logger = ::Logger.new(io)
  end
rescue LoadError
  require 'activesupport'
  RAILS_ENV            = 'test'
  RAILS_ROOT           = File.dirname(__FILE__)
  RAILS_DEFAULT_LOGGER = ::Logger.new(io)
  require 'initializer'
end

require 'silencer'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    allow(::Rails.logger).to receive(:level=).with(anything)
  end

end
