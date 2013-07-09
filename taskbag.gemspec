# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taskbag/version'

Gem::Specification.new do |spec|
  spec.name          = "taskbag"
  spec.version       = TaskBag::VERSION
  spec.authors       = ["Carlos Palhares"]
  spec.description   = spec.summary = "A simplistic task of bags implementation for multithreaded scripts"
  spec.authors       = ["Carlos Palhares"]
  spec.email         = 'me@xjunior.me'

  spec.homepage      = "https://github.com/xjunior/taskbag"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
