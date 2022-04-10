# frozen_string_literal: true

require 'spec_helper'

describe Silencer::Rack::Logger do
  let(:app) do
    lambda { |env|
      log = env['rack.logger']
      log.info('ohai')

      [200, {'Content-Type' => 'text/plain'}, ['Hello, World!']]
    }
  end

  let(:errors) do
    StringIO.new
  end

  it 'quiets the log when configured with a silenced path' do
    a = Rack::Lint.new(Silencer::Rack::Logger.new(app, silence: ['/']))
    Rack::MockRequest.new(a).get('/', 'rack.errors' => errors)
    expect(errors).not_to match('ohai')
  end

  it 'quiets the log when configured with a regex' do
    a = Rack::Lint.new(Silencer::Rack::Logger.new(app, silence: [/assets/]))
    Rack::MockRequest.new(a).get('/assets/application.css', 'rack.errors' => errors)
    expect(errors).not_to match('ohai')
  end

  %w[OPTIONS GET POST PUT DELETE PATCH].each do |method|
    it "quiets the log when configured with a silenced path for #{method} requests" do
      a = Rack::Lint.new(Silencer::Rack::Logger.new(app, method.downcase.to_sym => ['/']))
      Rack::MockRequest.new(a).send(method.downcase.to_sym, '/', 'rack.errors' => errors)
      expect(errors).not_to match('ohai')
    end

    it "quiets the log when configured with a regex for #{method} requests" do
      a = Rack::Lint.new(Silencer::Rack::Logger.new(app, method.downcase.to_sym => [/assets/]))
      Rack::MockRequest.new(a).send(method.downcase.to_sym, '/assets/application.css', 'rack.errors' => errors)
      expect(errors).not_to match('ohai')
    end
  end

  it 'quiets the log when configured with a regex for non-standard requests' do
    a = Rack::Lint.new(Silencer::Rack::Logger.new(app, silence: [/assets/]))
    Rack::MockRequest.new(a).get('/', 'rack.errors' => errors)
    expect(errors).not_to match('ohai')
  end

  it 'quiets the log when passed a custom header "X-SILENCE-LOGGER"' do
    a = Rack::Lint.new(Silencer::Rack::Logger.new(app))
    Rack::MockRequest.new(a).get('/', 'rack.errors' => errors, 'HTTP_X_SILENCE_LOGGER' => 'true')
    expect(errors).not_to match('ohai')
  end

  it 'does not tamper with the response' do
    a = Rack::Lint.new(Silencer::Rack::Logger.new(app))
    response = Rack::MockRequest.new(a).get('/', 'rack.errors' => errors, 'HTTP_X_SILENCE_LOGGER' => 'true')
    expect(response.status).to eq(200)
  end
end
