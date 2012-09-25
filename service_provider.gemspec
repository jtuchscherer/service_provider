# -*- encoding: utf-8 -*-
require File.expand_path('../lib/service_provider/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Johannes Tuchscherer"]
  gem.email         = ["jtuchscherer@gmail.com"]
  gem.description   = "This is an easy tool to acomplish basic dependency injection in Ruby"
  gem.summary       = "Dependency Injection in Ruby inspired by MethodDecorators"
  gem.homepage      = "https://github.com/jtuchscherer/service_provider"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "service_provider"
  gem.require_paths = ["lib"]
  gem.version       = ServiceProvider::VERSION
  
  gem.add_dependency "method_decorators"
  gem.add_development_dependency "rspec"
end
