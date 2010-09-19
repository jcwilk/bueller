module Gemspec
  def self.build(*files)
    Gem::Specification.new do |s|
      s.name = "bar"
      s.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
      s.email = "josh@technicalpickles.com"
      s.homepage = "http://github.com/technicalpickles/bueller"
      s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
      s.authors = ["Josh Nichols"]
      s.files = FileList[*files] unless files.empty?
      s.version = '0.1.1'

      s.add_runtime_dependency('bundler', '~> 1.0.0')
      s.add_runtime_dependency('git', '>= 1.2.5')
      s.add_runtime_dependency('rake', '>= 0')
      s.add_development_dependency('activesupport', '~> 2.3.5')
      s.add_development_dependency('bluecloth', '>= 0')
      s.add_development_dependency('cucumber', '>= 0')
      s.add_development_dependency('mhennemeyer-output_catcher', '>= 0')
      s.add_development_dependency('rcov', '>= 0')
      s.add_development_dependency('redgreen', '>= 0')
      s.add_development_dependency('rspec', '~> 2.0.0.beta.20')
      s.add_development_dependency('test-construct', '>= 0')
      s.add_development_dependency('timecop', '>= 0')
      s.add_development_dependency('yard', '~> 0.6.0')
    end
  end
end
