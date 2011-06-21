# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hashblue/version"

Gem::Specification.new do |s|
  s.name        = "hashblue"
  s.version     = Hashblue::VERSION
  s.authors     = ["Tom Ward"]
  s.email       = ["tom@popdog.net"]
  s.homepage    = "https://api.hashblue.com"
  s.summary     = %q{A simple client for the hashblue api}
  s.description = %q{A simple client for the hashblue api}

  s.rubyforge_project = "hashblue"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'httparty', '~>0.7.8'

  s.add_development_dependency 'rake', '~>0.9.2'
  s.add_development_dependency 'rspec', '~>2.6.0'
  s.add_development_dependency 'mocha'
end
