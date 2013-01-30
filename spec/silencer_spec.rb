require 'spec_helper'

describe Silencer::Logger do
  before(:each) do
    @app = lambda { |env| [200, {}, ''] }

    Rails.logger = stub('ActiveSupport::BufferedLogger').tap do |l|
      l.stub(:level).and_return(::Logger::INFO)
      l.stub(:level=).and_return(true)
      l.stub(:info)
    end
  end

  def should_silence_logger
    Rails.logger.should_receive(:level=).with(::Logger::ERROR).once
  end
  def should_not_silence_logger
    Rails.logger.should_not_receive(:level=).with(::Logger::ERROR)
  end

  it 'by default does not silence any requests or use any taggers' do
    should_not_silence_logger
    logger = Silencer::Logger.new(@app)
    logger.instance_variable_get(:@taggers).should == []
    logger.call(Rack::MockRequest.env_for("/"))
  end

  let(:log_tags) { [:uuid, :queue] }
  it 'instantiates with an optional taggers array' do
    should_silence_logger
    logger = Silencer::Logger.new(@app, log_tags, :silence => ['/'])
    logger.instance_variable_get(:@taggers).should == log_tags
    logger.call(Rack::MockRequest.env_for("/"))
  end

  it 'instantiates with an optional taggers array (using a splat)' do
    should_silence_logger
    logger = Silencer::Logger.new(@app, *log_tags, :silence => ['/'])
    logger.instance_variable_get(:@taggers).should == log_tags
    logger.call(Rack::MockRequest.env_for("/"))
  end

  it 'quiets the log when configured with a silenced path' do
    should_silence_logger
    Silencer::Logger.new(@app, :silence => ['/']).call(Rack::MockRequest.env_for("/"))
  end

  it 'quiets the log when configured with a regex' do
    should_silence_logger
    Silencer::Logger.new(@app, :silence => [/assets/]).call(Rack::MockRequest.env_for("/assets/application.css"))
  end

  it 'quiets the log when passed a custom header "X-SILENCE-LOGGER"' do
    should_silence_logger
    Silencer::Logger.new(@app).call(Rack::MockRequest.env_for("/", 'X-SILENCE-LOGGER' => 'true'))
  end

  it 'does not tamper with the response' do
    response = Silencer::Logger.new(@app).call(Rack::MockRequest.env_for("/", 'X-SILENCE-LOGGER' => 'true'))
    response[0].should eq(200)
  end
end
