Gem::Specification.new do |s|
  s.name        = 'Robottler'
  s.version     = '0.0.0'
  s.licenses    = ['MIT']
  s.summary     = "Simple gem to generate ui tests for you app by looking at your manifest."
  s.description = "Simple gem to generate ui tests for you app by looking at your manifest. Default tests will be espresso tests with spoon integration for taking screenshots."
  s.authors     = ["tosa"]
  s.email       = 'tosa.info@gmail.com'
  s.files       = Dir['Rakefile', '{bin,lib,test,templates}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  s.homepage    = 'https://github.com/tobibo/robottler'
  s.executables = 'robottler'
  s.add_dependency 'nokogiri'
end