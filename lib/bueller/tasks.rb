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
    attr_accessor :bueller

    def initialize
      Rake.application.bueller_tasks = self
      define
    end

    def bueller
      @bueller ||= Bueller.new
    end

  private

    def define
      task :gemspec_required do
        unless File.exist?(bueller.gemspec_helper.path)
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

      namespace :gemspec do
        desc 'Validates the gemspec'
        task :validate => :gemspec_required do
          if bueller.gemspec_helper.valid?
            puts "Gemspec is valid"
            true
          else
            puts "Gemspec is not valid"
            false
          end
        end
      end

      desc "Displays the current version"
      task :version do
        $stdout.puts "Current version: #{bueller.version}"
      end

      namespace :version do
        desc "Writes out an explicit version. Respects the following environment variables, or defaults to 0: MAJOR, MINOR, PATCH. Also recognizes BUILD, which defaults to nil"
        task :write do
          major, minor, patch, build = ENV['MAJOR'].to_i, ENV['MINOR'].to_i, ENV['PATCH'].to_i, (ENV['BUILD'] || nil )
          bueller.write_version(major, minor, patch, build)
          $stdout.puts "Updated version: #{bueller.version}"
        end

        namespace :bump do
          desc "Bump the gemspec by a major version."
          task :major => :version do
            bueller.bump_major_version
            bueller.write_gemspec
            $stdout.puts "Updated version: #{bueller.version}"
          end

          desc "Bump the gemspec by a minor version."
          task :minor => :version do
            bueller.bump_minor_version
            bueller.write_gemspec
            $stdout.puts "Updated version: #{bueller.version}"
          end

          desc "Bump the gemspec by a patch version."
          task :patch => :version do
            bueller.bump_patch_version
            bueller.write_gemspec
            $stdout.puts "Updated version: #{bueller.version}"
          end
        end
      end

      desc "Release gem"
      task :release do
      end

      namespace :git do
        desc "Tag a release and push to origin"
        task :release do
          bueller.git_tag_release
        end
      end

      task :release => 'git:release'

      namespace :rubygems do
        desc "Release gem to Rubygems"
        task :release => [:gemspec, :build] do
          bueller.release_gem_to_rubygems
        end
      end

      task :release => 'rubygems:release'
    end
  end
end
