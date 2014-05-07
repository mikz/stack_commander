# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stack_commander/version'

Gem::Specification.new do |spec|
  spec.name          = 'stack_commander'
  spec.version       = StackCommander::VERSION
  spec.authors       = ['Michal Cichra']
  spec.email         = %w[michal@3scale.net]
  spec.summary       = %q{Mix between command pattern and stack execution}
  spec.description   = %q{Write simple commands that execute on stack}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'yard'
end
