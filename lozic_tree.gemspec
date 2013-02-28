# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lozic_tree/version"

Gem::Specification.new do |s|
  s.name        = 'lozic_tree'
  s.version     = LozicTree::VERSION
  s.authors     = ["Raj Bhandari"]
  s.email       = ["@playup.com"]
  s.homepage    = "https://github.com/dhirajbhandari/lozic_tree"
  s.summary     = %q{Serialize logical expression tree using JSON}
  s.description = %q{Serialize logical expression tree using JSON}

  #s.rubyforge_project = "lozic_tree"


  # json lib
  s.add_dependency 'json'

  s.add_development_dependency  'rake'
  s.add_development_dependency  'rspec'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
