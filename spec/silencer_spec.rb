require 'spec_helper'

describe Silencer::Logger do
  before(:each) do
    @app = lambda { |env| [200, {}, ''] }

    Rails.logger = stub('ActiveSupport::BufferedLogger').tap do |l|
      l.stub(:level).and_return(::Logger::INFO)
      l.stub(:level=).and_return(true)
    end
  end

  it 'allows log writing when not implemented' do
    Rails.logger.should_not_receive(:level=).with(::Logger::ERROR)

    Silencer::Logger.new(@app).call(Rack::MockRequest.env_for("/"))
  end

  it 'quiets the log when configured with a silenced path' do
    Rails.logger.should_not_receive(:info)
    Rails.logger.should_receive(:level=).with(::Logger::ERROR).once

    Silencer::Logger.new(@app, :silence => ['/']).call(Rack::MockRequest.env_for("/"))
  end

  it 'quiets the log when configured with a regex' do
    Rails.logger.should_not_receive(:info)
    Rails.logger.should_receive(:level=).with(::Logger::ERROR).once

    Silencer::Logger.new(@app, :silence => [/assets/]).call(Rack::MockRequest.env_for("/assets/application.css"))
  end

  it 'quiets the log when passed a custom header "X-SILENCE-LOGGER"' do
    Rails.logger.should_not_receive(:info)
    Rails.logger.should_receive(:level=).with(::Logger::ERROR).once

    Silencer::Logger.new(@app).call(Rack::MockRequest.env_for("/", 'X-SILENCE-LOGGER' => 'true'))
  end

  it 'does not tamper with the response' do
    response = Silencer::Logger.new(@app).call(Rack::MockRequest.env_for("/", 'X-SILENCE-LOGGER' => 'true'))
    response[0].should eq(200)
  end
end