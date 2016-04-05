source 'https://rubygems.org'

gem 'rake'
gem 'yard'

gem 'rails', (ENV['RAILS_VERSION'] || '4.2.6')
gem 'rack'

group :development do
  gem 'kramdown'
  gem 'guard-rspec'
end

group :test do
  gem 'rspec'
  gem 'iconv', require: false
  gem 'simplecov', require: false
end

gemspec
