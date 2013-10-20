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

require 'logger'
require 'stringio'

io = StringIO.new

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    ::Rails.logger = ::Logger.new(io)
    allow(::Rails.logger).to receive(:level=).with(anything)
  end

end
