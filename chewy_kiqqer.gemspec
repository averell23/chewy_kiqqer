# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chewy_kiqqer/version'

Gem::Specification.new do |spec|
  spec.name          = "chewy_kiqqer"
  spec.version       = ChewyKiqqer::VERSION
  spec.authors       = ["Daniel Hahn"]
  spec.email         = ["dha@betterplace.org"]
  spec.description   = %q{Sidekiq integration for chewy and sidekiq}
  spec.summary       = %q{Small helper gem that allows you to automatically run all chewy index updates in sidekiq}
  spec.homepage      = ""
  spec.license       = "Apache V2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sidekiq'
  spec.add_dependency 'chewy'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "kaminari"
  spec.add_development_dependency "rspec"
end
