require 'spec_helper'

describe Silencer::Rails::Logger do
  let(:app)       { ->(_env) { [200, {}, ''] } }
  let(:log_tags)  { [:uuid, :queue] }

  context 'quieted' do
    before do
      expect_any_instance_of(Silencer::Rails::Logger).to receive(:quiet).at_least(:once).and_call_original
    end

    it 'quiets the log when configured with a silenced path' do
      Silencer::Rails::Logger.new(app, silence: ['/'])
                             .call(Rack::MockRequest.env_for('/'))
    end

    it 'quiets the log when configured with a regex' do
      Silencer::Rails::Logger.new(app, silence: [/assets/])
                             .call(Rack::MockRequest.env_for('/assets/application.css'))
    end

    %w(OPTIONS GET HEAD POST PUT DELETE TRACE CONNECT PATCH).each do |method|
      it "quiets the log when configured with a silenced path for #{method} requests" do
        Silencer::Rails::Logger.new(app, method.downcase.to_sym => ['/'])
                               .call(Rack::MockRequest.env_for('/', method: method))
      end

      it "quiets the log when configured with a regex for #{method} requests" do
        Silencer::Rails::Logger.new(app, method.downcase.to_sym => [/assets/])
                               .call(Rack::MockRequest.env_for('/assets/application.css', method: method))
      end
    end

    it 'quiets the log when configured with a silenced path for non-standard requests' do
      Silencer::Rails::Logger.new(app, silence: ['/'])
                             .call(Rack::MockRequest.env_for('/', method: 'UPDATE'))
    end

    it 'quiets the log when configured with a regex for non-standard requests' do
      Silencer::Rails::Logger.new(app, silence: [/assets/])
                             .call(Rack::MockRequest.env_for('/assets/application.css', method: 'UPDATE'))
    end

    it 'quiets the log when passed a custom header "X-SILENCE-LOGGER"' do
      Silencer::Rails::Logger.new(app)
                             .call(Rack::MockRequest.env_for('/', 'HTTP_X_SILENCE_LOGGER' => 'true'))
    end

    it 'does not tamper with the response' do
      response = Silencer::Rails::Logger.new(app)
                                        .call(Rack::MockRequest.env_for('/', 'HTTP_X_SILENCE_LOGGER' => 'true'))

      expect(response[0]).to eq(200)
    end

    it 'instantiates with an optional taggers array' do
      Silencer::Rails::Logger.new(app, log_tags, silence: ['/'])
                             .call(Rack::MockRequest.env_for('/'))
    end if Silencer::Environment.tagged_logger?

    it 'instantiates with an optional taggers array passed as args' do
      Silencer::Rails::Logger.new(app, :uuid, :queue, silence: ['/'])
                             .call(Rack::MockRequest.env_for('/'))
    end if Silencer::Environment.tagged_logger?
  end

  it 'silences' do
    logger = Silencer::Rails::Logger.new(app, silence: ['/'])

    if ::Rails.logger.respond_to?(:silence)
      expect(::Rails.logger).to receive(:silence).at_least(:once)
    else
      expect(::Rails.logger).to receive(:level=)
        .with(::Logger::ERROR).at_least(:once)
    end

    logger.call(Rack::MockRequest.env_for('/'))
  end
end
