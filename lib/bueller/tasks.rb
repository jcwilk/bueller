require 'rake'
require 'rake/tasklib'

class Rake::Application
  attr_accessor :bueller_tasks

  # The bueller instance that has be instantiated in the current Rakefile.
  #
  # This is usually useful if you want to get at info like version from other files.
  def bueller
    bueller_tasks.bueller
  end
end

class Bueller
  # Rake tasks for managing your gem.
  #
  # Here's a basic example of using it:
  #
  #   Bueller::Tasks.new
  class Tasks < ::Rake::TaskLib
    attr_accessor :gemspec, :bueller

    def initialize(name)
      @gemspec = gemspec || eval(File.read(File.join(Dir.pwd, "#{name}.gemspec")))

      Rake.application.bueller_tasks = self
      define
    end

    def bueller
      if @bueller.nil?
        @bueller = Bueller.new(gemspec)
      end
      @bueller
    end

  private

    def yield_gemspec_set_version?
      yielded_gemspec = @gemspec.dup
      yielded_gemspec.extend(Bueller::Specification)
      yielded_gemspec.files = FileList[]
      yielded_gemspec.test_files = FileList[]
      yielded_gemspec.extra_rdoc_files = FileList[]

      ! yielded_gemspec.version.nil?
    end

    def define
      task :version_required do
        if bueller.expects_version_file? && !bueller.version_file_exists?
          abort "Expected VERSION or VERSION.yml to exist. Use 'rake version:write' to create an initial one."
        end
      end

      task :gemspec_required do
        if ! File.exist?(bueller.gemspec_helper.path)
          abort "Expected #{bueller.gemspec_helper.path} to exist. See 'rake gemspec:write' to create it"
        end
      end
      

      desc "Build gem"
      task :build do
        bueller.build_gem
      end

      desc "Install gem"
      task :install => [:build] do
        bueller.install_gem
      end

      desc "Generate and validates gemspec"
      task :gemspec => ['gemspec:generate', 'gemspec:validate']

      namespace :gemspec do
        desc "Validates the gemspec"
        task :validate => :gemspec_required do
          bueller.validate_gemspec
        end

        desc "Generates the gemspec, using version from VERSION"
        task :generate => :version_required do
          bueller.write_gemspec
        end
      end

      desc "Displays the current version"
      task :version => :version_required do
        $stdout.puts "Current version: #{bueller.version}"
      end

      namespace :version do
        desc "Writes out an explicit version. Respects the following environment variables, or defaults to 0: MAJOR, MINOR, PATCH. Also recognizes BUILD, which defaults to nil"
        task :write do
          major, minor, patch, build = ENV['MAJOR'].to_i, ENV['MINOR'].to_i, ENV['PATCH'].to_i, (ENV['BUILD'] || nil )
          bueller.write_version(major, minor, patch, build, :announce => false, :commit => false)
          $stdout.puts "Updated version: #{bueller.version}"
        end

        namespace :bump do
          desc "Bump the gemspec by a major version."
          task :major => [:version_required, :version] do
            bueller.bump_major_version
            bueller.write_gemspec
            $stdout.puts "Updated version: #{bueller.version}"
          end

          desc "Bump the gemspec by a minor version."
          task :minor => [:version_required, :version] do
            bueller.bump_minor_version
            bueller.write_gemspec
            $stdout.puts "Updated version: #{bueller.version}"
          end

          desc "Bump the gemspec by a patch version."
          task :patch => [:version_required, :version] do
            bueller.bump_patch_version
            bueller.write_gemspec
            $stdout.puts "Updated version: #{bueller.version}"
          end
        end
      end

      desc "Release gem"
      task :release do
      end

      namespace :github do
        desc "Release Gem to GitHub"
        task :release do
          bueller.release_gem_to_github
        end
      end

      task :release => 'github:release'

      namespace :git do
        desc "Tag a release in Git"
        task :release do
          bueller.release_to_git
        end
      end

      task :release => 'git:release'

      namespace :gemcutter do
        desc "Release gem to Gemcutter"
        task :release => [:gemspec, :build] do
          bueller.release_gem_to_gemcutter
        end
      end

      task :release => 'gemcutter:release'

      desc "Check that runtime and development dependencies are installed" 
      task :check_dependencies do
        puts "Use bundle install instead"
        `bundle install`
      end

      namespace :check_dependencies do
        desc "Check that runtime dependencies are installed"
        task :runtime  do
          puts "Use bundle install instead"
          `bundle install`
        end

        desc"Check that development dependencies are installed"
        task :development do
          puts "Use bundle install instead"
          `bundle install`
        end
      end

      desc "Start IRB with all runtime dependencies loaded"
      task :console do
        puts "Use bundle console instead"
        `bundle console`
      end
      
    end
  end
end
