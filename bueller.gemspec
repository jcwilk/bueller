Gem::Specification.new do |s|
  s.name = %q{bueller}
  s.version = "0.0.1"
  s.date = '2010-02-15'
  s.authors = ['Josh Nichols', 'Derek Kastner']
  s.email = 'dkastner@gmail.com'
  s.homepage = 'http://github.com/dkastner/bueller'
  s.description = 'Simpler and opinionateder helper for creating Rubygem projects on GitHub'
  s.summary = 'Simple and opinionated helper for creating Rubygem projects on GitHub'
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = [
    "ChangeLog.markdown",
    "LICENSE",
    "README.markdown",
  ]

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.7")
  s.rubygems_version = '1.3.7'
  s.specification_version = 3

  s.require_paths = ['lib']
  s.executables = ['bueller']
  s.default_executable = 'bueller'
  s.files = Dir.glob('lib/**/*.rb')
  s.test_files = Dir.glob('spec/**/*.rb')

  s.add_runtime_dependency 'bundler', '~> 1.0.0'
  s.add_runtime_dependency 'git', '>= 1.2.5'
  s.add_runtime_dependency 'rake', '>= 0'
  s.add_runtime_dependency 'ruby_parser'
  s.add_runtime_dependency 'ruby2ruby'
  s.add_development_dependency('activesupport', '~> 2.3.5')
  s.add_development_dependency('bluecloth', '>= 0')
  s.add_development_dependency('cucumber', '>= 0')
  s.add_development_dependency('mhennemeyer-output_catcher', '>= 0')
  s.add_development_dependency('rcov', '>= 0')
  s.add_development_dependency('redgreen', '>= 0')
  s.add_development_dependency('rspec', '~> 2.0.0')
  s.add_development_dependency('sandbox')
  s.add_development_dependency('timecop', '>= 0')
  s.add_development_dependency('yard', '~> 0.6.0')
end

