# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "simplex"
  spec.version       = '1.0'
  spec.authors       = ["Andrei Nadejde"]
  spec.email         = ["andrei.nadejde@gmail.com"]
  spec.summary       = %q{Implementation of the simplex algoritm. Solves general linear programming problems.}
  spec.description   = %q{Simplex algoritm implementation. 
                        Used to solve general linear programming problems. 
                        This means any kind of linear programming not just standard ones.}
  spec.homepage      = "http://nadejde.ro/"
  spec.license       = "MIT"

  spec.files         = ['lib/simplex.rb']
  spec.executables   = ['bin/simplex']
  spec.test_files    = ['tests/test_simplex.rb']
  spec.require_paths = ["lib"]
end