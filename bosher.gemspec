# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bosher/version'

Gem::Specification.new do |spec|
  spec.name          = "bosher"
  spec.version       = Bosher::VERSION
  spec.authors       = ["Luan Santos and Serguei Filimonov"]
  spec.email         = ["pair+luan+sfilimonov@pivotallabs.com"]
  spec.summary       = %q{bosh simulator}
  spec.description   = %q{simulates bosh template writing}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
