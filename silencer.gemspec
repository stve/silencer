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

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'rdiscount'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'

  gem.add_dependency 'railties', '>= 3'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]
end
