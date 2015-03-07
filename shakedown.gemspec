# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shakedown/version'

Gem::Specification.new do |spec|
  spec.name          = "shakedown"
  spec.version       = Shakedown::VERSION
  spec.authors       = ["Casey O'Hara"]
  spec.email         = ["casey@camber.io"]
  spec.summary       = "Lightweight, implementation-agnostic JSON API tests"
  spec.description   = ""
  spec.homepage      = "https://github.com/camber/shakedown"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "formatador", "~> 0.2.5"
end

