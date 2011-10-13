# -*- encoding: utf-8 -*-
require File.expand_path('../lib/silencer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "silencer"
  gem.version       = Silencer::VERSION
  gem.authors       = ["Steve Agalloco"]
  gem.email         = ["steve.agalloco@gmail.com"]
  gem.homepage      = "http://github.com/spagalloco/silencer"
  gem.description   = 'Selectively quiet your Rails logger on a per-action basis'
  gem.summary       = gem.description

  gem.add_development_dependency('rake', '~> 0.9')
  gem.add_development_dependency('rspec', '~> 2.6')
  gem.add_development_dependency('yard', '~> 0.7')
  gem.add_development_dependency('rdiscount', '~> 1.6')
  gem.add_development_dependency('simplecov', '~> 0.5')
  gem.add_development_dependency('guard', '~> 0.8')
  gem.add_development_dependency('guard-rspec', '~> 0.5')

  gem.add_dependency 'railties', '~> 3'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]
end
