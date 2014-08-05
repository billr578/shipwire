# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shipwire/version'

Gem::Specification.new do |spec|
  spec.name          = "shipwire"
  spec.version       = Shipwire::VERSION
  spec.authors       = ["Bill Rowell"]
  spec.email         = ["billr578@gmail.com"]
  spec.summary       = %q{Exchange data with Shipwire fullfillment}
  spec.description   = %q{Provides a wrapper for API calls to Shipwire fullfillment}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "rack-test"

  spec.add_development_dependency "dotenv"

  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "pry"
end
