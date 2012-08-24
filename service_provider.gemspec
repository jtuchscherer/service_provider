# -*- encoding: utf-8 -*-
require File.expand_path('../lib/service_provider/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Your Name"]
  gem.email         = ["jtuchscherer@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "service_provider"
  gem.require_paths = ["lib"]
  gem.version       = ServiceProvider::VERSION
  
  gem.add_dependency "method_decorators"
  gem.add_development_dependency "rspec"
end
