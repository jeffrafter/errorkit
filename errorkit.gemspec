# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'errorkit/version'

Gem::Specification.new do |spec|
  spec.name          = "errorkit"
  spec.version       = Errorkit::VERSION
  spec.authors       = ["Jeff Rafter"]
  spec.email         = ["jeffrafter@gmail.com"]
  spec.description   = %q{ErrorKit allows you to track errors within your application and generate a notification when they happen.}
  spec.summary       = %q{ErrorKit allows you to track errors within your application and generate a notification when they happen.}
  spec.homepage      = "http://github.com/jeffrafter/errorkit"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
