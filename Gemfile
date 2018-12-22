source 'https://rubygems.org'

gem 'rake'
gem 'yard'

gem 'rack'
gem 'rails', (ENV['RAILS_VERSION'] || '5.2.2')

group :development do
  gem 'kramdown'
end

group :test do
  gem 'rspec', '3.5'
  gem 'rubocop'
  gem 'simplecov', require: false
end

group :test, :development do
  gem 'syslogger'
end

gemspec
