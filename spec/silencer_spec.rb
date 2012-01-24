require 'spec_helper'

describe Silencer::Logger do
  before(:each) do
    @app = lambda { |env| [200, {}, ''] }

    Rails.logger = ActiveSupport::BufferedLogger.new('tmp/test.log')
  end

  it 'allows log writing when not implemented' do
    Rails.logger.should_not_receive(:silence)
    Rails.logger.should_receive(:info).at_least(:once)

    Silencer::Logger.new(@app).call(Rack::MockRequest.env_for("/"))
  end

  it 'quiets the log when configured with a silenced path' do
    Rails.logger.should_receive(:silence)
    Rails.logger.should_not_receive(:info)

    Silencer::Logger.new(@app, :silence => ['/']).call(Rack::MockRequest.env_for("/"))
  end

  it 'quiets the log when configured with a regex' do
    Rails.logger.should_receive(:silence)
    Rails.logger.should_not_receive(:info)

    Silencer::Logger.new(@app, :silence => [/assets/]).call(Rack::MockRequest.env_for("/assets/application.css"))
  end

  it 'quiets the log when passed a custom header "X-SILENCE-LOGGER"' do
    Rails.logger.should_receive(:silence)
    Rails.logger.should_not_receive(:info)

    Silencer::Logger.new(@app).call(Rack::MockRequest.env_for("/", 'X-SILENCE-LOGGER' => 'true'))
  end

  it 'does not tamper with the response' do
    response = Silencer::Logger.new(@app).call(Rack::MockRequest.env_for("/", 'X-SILENCE-LOGGER' => 'true'))
    response[0].should eq(200)
  end
end