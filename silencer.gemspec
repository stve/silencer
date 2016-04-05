# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'silencer/version'

Gem::Specification.new do |gem|
  gem.name          = "silencer"
  gem.version       = Silencer::VERSION
  gem.authors       = ["Steve Agalloco"]
  gem.email         = ["steve.agalloco@gmail.com"]
  gem.homepage      = "http://github.com/spagalloco/silencer"
  gem.description   = 'Selectively quiet your Rails/Rack logger on a per-route basis'
  gem.summary       = gem.description

  gem.files = %w(.yardopts LICENSE.md README.md Rakefile silencer.gemspec)
  gem.files += Dir.glob("lib/**/*.rb")

  gem.test_files = Dir.glob("spec/**/*")

  gem.require_paths = ["lib"]
end
