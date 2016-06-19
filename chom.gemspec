# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chom/version'

Gem::Specification.new do |spec|
  spec.name          = 'chom'
  spec.version       = Chom::VERSION
  spec.authors       = ['Sean Lerner']
  spec.email         = ['sean@smallcity.ca']

  spec.summary       = 'Utility to chown and chmod a folder recursive so web app has write access to folder.'
  spec.homepage      = 'https://gitlab.com/seanlerner/chom'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'yard', '~> 0.8'
end
