# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shipwire/version'

Gem::Specification.new do |spec|
  spec.name          = "shipwire"
  spec.version       = Shipwire::VERSION
  spec.authors       = ["Bill Rowell"]
  spec.email         = ["billr578@gmail.com"]
  spec.summary       = 'Exchange data with Shipwire fullfillment'
  spec.description   = 'Provides a wrapper for API calls to Shipwire'
  spec.homepage      = "https://github.com/morbid-enterprises/shipwire"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails"
  spec.add_dependency "faraday", "~> 0.9.1"
  spec.add_dependency "recursive-open-struct", "~> 0.6.4"

  spec.add_development_dependency "rspec",  "~> 3.2.0"
  spec.add_development_dependency "ffaker", "~> 2.0.0"
  spec.add_development_dependency "simplecov", "~> 0.10.0"
  spec.add_development_dependency "vcr", "~> 2.9.3"
  spec.add_development_dependency "webmock", "~> 1.21.0"
  spec.add_development_dependency "pry", "~> 0.10.1"
end
