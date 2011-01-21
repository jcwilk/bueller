Gem::Specification.new do |s|
  s.name = 'bueller'
  s.version = "0.0.3"
  s.date = "2011-01-21"
  s.authors = ['Derek Kastner']
  s.email = 'dkastner@gmail.com'
  s.homepage = 'http://github.com/dkastner/bueller'
  s.summary = 'Tools for building gems with bundler and friends'
  s.description = 'Bueller provides a command to create new gem project directories. Code to help you start testing is generated according to the testing framework you choose. Bueller also provides handy tools for versioning and releasing your gem to github and rubygems.'
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown"
  ]

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.7")
  s.rubygems_version = '1.3.7'
  s.specification_version = 3

  s.require_paths = ['lib']
  s.executables = ['bueller']
  s.default_executable = 'bueller'
  s.files = Dir.glob('lib/**/*') + Dir.glob('bin/**/*') + 
              ['lib/bueller/templates/.gitignore',
               'lib/bueller/templates/.document',
               'lib/bueller/templates/rspec/.rspec']
  s.test_files = Dir.glob('spec/**/*')

  s.add_runtime_dependency 'bundler', '~> 1.0.0'
  s.add_runtime_dependency 'git', '>= 1.2.5'
  s.add_runtime_dependency 'rake'
  s.add_development_dependency 'activesupport', '~> 2.3.5'
  s.add_development_dependency 'bluecloth'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'mhennemeyer-output_catcher'
  s.add_development_dependency 'redgreen'
  s.add_development_dependency 'rspec', '~> 2.0.0'
  s.add_development_dependency 'sandbox'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'yard', '~> 0.6.0'
end

