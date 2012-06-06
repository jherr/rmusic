# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rmusic/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jack Herrington"]
  gem.email         = ["jherr@pobox.com"]
  gem.description   = %q{A Music Theory library for Ruby}
  gem.summary       = %q{This library contains a set of Ruby classes for working with music theory. Particularly on stringed instruments.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rmusic"
  gem.require_paths = ["lib"]
  gem.version       = Rmusic::VERSION
  
  gem.add_development_dependency "rspec", "~> 2.6"
end

