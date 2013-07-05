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
  gem.description   = 'Selectively quiet your Rails logger on a per-action basis'
  gem.summary       = gem.description

  gem.add_dependency 'railties', '>= 3'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]
end
