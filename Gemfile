source 'http://rubygems.org'

gem 'rake'
gem 'yard'

rails_version = case ENV['RAILS_VERSION']
  when nil then '4.0.0'
  else ENV['RAILS_VERSION']
  end

gem 'rails', rails_version
gem 'rack'

group :development do
  gem 'kramdown'
  gem 'guard-rspec'
end

group :test do
  gem 'rspec'
  gem 'simplecov', :require => false
end

gemspec
