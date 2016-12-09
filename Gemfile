source 'https://rubygems.org'

gem 'rake'
gem 'yard'

gem 'rails', (ENV['RAILS_VERSION'] || '5.0.0.1')
gem 'rack'

group :development do
  gem 'kramdown'
end

group :test do
  gem 'rspec', '3.5'
  gem 'rubocop'
  gem 'iconv', require: false
  gem 'simplecov', require: false
end

gemspec
