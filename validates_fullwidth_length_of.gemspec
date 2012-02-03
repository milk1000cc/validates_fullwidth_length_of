# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "validates_fullwidth_length_of/version"

Gem::Specification.new do |s|
  s.name        = "validates_fullwidth_length_of"
  s.version     = ValidatesFullwidthLengthOf::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["milk1000cc", "necolt"]
  s.email       = ["info@necolt.com"]
  s.homepage    = "http://rubygems.org/gems/validates_fullwidth_length_of"
  s.summary     = %q{Validates fullwidth length of}
  s.description = %q{Validates fullwidth length of for unicode symbols}

  s.rubyforge_project = "validates_fullwidth_length_of"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'activerecord', '~> 3.0.0'

  s.add_development_dependency 'rspec', '>= 2.0.0'
  s.add_development_dependency 'sqlite3'
end
