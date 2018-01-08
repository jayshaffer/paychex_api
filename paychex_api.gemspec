# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'paychex_api/version'

Gem::Specification.new do |gem|
  gem.authors =       ["Jay Shaffer"]
  gem.email =         ["jshaffer@instructure.com"]
  gem.description =   %q{Interface for interacting with the paychex enterprise API}
  gem.summary =       %q{Paychex API}
  gem.homepage =      ""
  gem.license = 'MIT'

  gem.files = `git ls-files`.split("\n")
  gem.files += Dir.glob("lib/**/*.rb")
  gem.files += Dir.glob("spec/**/*")
  gem.test_files    = Dir.glob("spec/**/*")
  gem.name          = "paychex_api"
  gem.require_paths = ["lib"]
  gem.version       = PaychexAPI::VERSION

  gem.add_development_dependency 'rake', '~> 0'
  gem.add_development_dependency 'bundler', '~> 1.0', '>= 1.0.0'
  gem.add_development_dependency 'rspec', '~> 2.6'
  gem.add_development_dependency 'webmock', '~>1.22.6'
  gem.add_development_dependency 'pry', '~> 0'
  gem.add_development_dependency 'tilt', '>= 1.3.4', '~> 1.3'
  gem.add_development_dependency 'sinatra', '~> 1.0'
  gem.add_development_dependency 'byebug', '~> 8.2.2'

  gem.add_dependency 'footrest', '>= 0.5.1'
  gem.add_dependency 'faraday', '~> 0.9.0'
  gem.add_dependency 'faraday_middleware', '~> 0.9.0'

end
