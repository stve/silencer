require 'spec_helper'

describe Silencer::Rails::Logger do
  let(:app)       { lambda { |env| [200, {}, ''] } }
  let(:log_tags)  { [:uuid, :queue] }

  it 'quiets the log when configured with a silenced path' do
    expect(::Rails.logger).to receive(:level=).
      with(::Logger::ERROR).at_least(:once)

    Silencer::Rails::Logger.new(app, :silence => ['/']).
      call(Rack::MockRequest.env_for("/"))
  end

  it 'quiets the log when configured with a regex' do
    expect(::Rails.logger).to receive(:level=).
      with(::Logger::ERROR).at_least(:once)

    Silencer::Rails::Logger.new(app, :silence => [/assets/]).
      call(Rack::MockRequest.env_for("/assets/application.css"))
  end

  it 'quiets the log when passed a custom header "X-SILENCE-LOGGER"' do
    expect(::Rails.logger).to receive(:level=).
      with(::Logger::ERROR).at_least(:once)

    Silencer::Rails::Logger.new(app).
      call(Rack::MockRequest.env_for("/", 'HTTP_X_SILENCE_LOGGER' => 'true'))
  end

  it 'does not tamper with the response' do
    response = Silencer::Rails::Logger.new(app).
      call(Rack::MockRequest.env_for("/", 'HTTP_X_SILENCE_LOGGER' => 'true'))

    expect(response[0]).to eq(200)
  end

  it 'instantiates with an optional taggers array' do
    expect(::Rails.logger).to receive(:level=).
      with(::Logger::ERROR).at_least(:once)

    Silencer::Rails::Logger.new(app, log_tags, :silence => ['/']).
      call(Rack::MockRequest.env_for("/"))
  end if Silencer::Environment.tagged_logger?

  it 'instantiates with an optional taggers array passed as args' do
    expect(::Rails.logger).to receive(:level=).
      with(::Logger::ERROR).at_least(:once)

    Silencer::Rails::Logger.new(app, :uuid, :queue, :silence => ['/']).
      call(Rack::MockRequest.env_for("/"))
  end if Silencer::Environment.tagged_logger?

end
