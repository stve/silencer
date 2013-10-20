require 'spec_helper'

describe Silencer::Rack::Logger do
  let(:app) { lambda { |env| [200, {}, ''] } }

  it 'quiets the log when configured with a silenced path' do
    expect_any_instance_of(::Logger).to receive(:level=).with(::Logger::ERROR)

    Silencer::Rack::Logger.new(app, :silence => ['/']).
      call(Rack::MockRequest.env_for("/"))
  end

  it 'quiets the log when configured with a regex' do
    expect_any_instance_of(::Logger).to receive(:level=).with(::Logger::ERROR)

    Silencer::Rack::Logger.new(app, :silence => [/assets/]).
      call(Rack::MockRequest.env_for("/assets/application.css"))
  end

  it 'quiets the log when passed a custom header "X-SILENCE-LOGGER"' do
    expect_any_instance_of(::Logger).to receive(:level=).with(::Logger::ERROR)

    Silencer::Rack::Logger.new(app).
      call(Rack::MockRequest.env_for("/", 'HTTP_X_SILENCE_LOGGER' => 'true'))
  end

  it 'does not tamper with the response' do
    response = Silencer::Rack::Logger.new(app).
      call(Rack::MockRequest.env_for("/", 'HTTP_X_SILENCE_LOGGER' => 'true'))

    expect(response[0]).to eq(200)
  end
end
