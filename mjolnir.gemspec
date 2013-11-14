Gem::Specification.new do |s|
  s.name        = 'mjolnir'
  s.version     = '0.1.0'
  s.date        = '2013-11-14'
  s.summary     = "Mjolnir"
  s.description = "Mjolnir - a java source code generator for json processing"
  s.authors     = ["Lukasz Wisniewski"]
  s.email       = 'luke.cherrish@gmail.com'
  s.files       = ["lib/mjolnir.rb", "assets/javaclass.erb"]
  s.homepage    = 'http://rubygems.org/gems/mjolnir'
  s.license     = 'Apache 2.0'
  s.executables += ['mjolnir-package','mjolnir-sketch']
end