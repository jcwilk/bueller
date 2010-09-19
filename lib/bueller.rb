require 'date'

# A Bueller helps you craft the perfect Rubygem. Give him a gemspec, and he takes care of the rest.
#
# See Bueller::Tasks for examples of how to get started. Additionally, resources are available on the wiki:
#
# * http://wiki.github.com/technicalpickles/bueller/create-a-new-project
# * http://wiki.github.com/technicalpickles/bueller/configure-an-existing-project
class Bueller
  require 'bueller/errors'
  require 'rubygems/user_interaction'

  autoload :Generator,      'bueller/generator'

  autoload :Commands,       'bueller/commands'
  
  autoload :VersionHelper,  'bueller/version_helper'
  autoload :GemSpecHelper,  'bueller/gemspec_helper'

  autoload :Tasks,          'bueller/tasks'
  autoload :GemcutterTasks, 'bueller/gemcutter_tasks'
  autoload :RubyforgeTasks, 'bueller/rubyforge_tasks'

  attr_reader :gemspec, :gemspec_helper, :version_helper
  attr_accessor :base_dir, :output, :repo, :commit

  def initialize(gemspec, base_dir = '.')
    @gemspec = gemspec

    @base_dir       = base_dir
    @repo           = Git.open(git_base_dir) if in_git_repo?
    @version_helper = Bueller::VersionHelper.new gemspec
    @output         = $stdout
    @commit         = true
    @gemspec_helper = GemSpecHelper.new(gemspec, base_dir)
  end

  # Major version, as defined by the gemspec's Version module.
  # For 1.5.3, this would return 1.
  def major_version
    @version_helper.major
  end

  # Minor version, as defined by the gemspec's Version module.
  # For 1.5.3, this would return 5.
  def minor_version
    @version_helper.minor
  end

  # Patch version, as defined by the gemspec's Version module.
  # For 1.5.3, this would return 5.
  def patch_version
    @version_helper.patch
  end

  # Human readable version, which is used in the gemspec.
  def version
    @gemspec.version || @version_helper.to_s
  end

  # Writes out the gemspec
  def write_gemspec
    Bueller::Commands::WriteGemspec.run_for(self)
  end

  # Validates the project's gemspec from disk in an environment similar to how 
  # GitHub would build from it. See http://gist.github.com/16215
  def validate_gemspec
    Bueller::Commands::ValidateGemspec.run_for(self)
  end

  # is the project's gemspec from disk valid?
  def valid_gemspec?
    gemspec_helper.valid?
  end

  # Build a gem using the project's latest Gem::Specification
  def build_gem
    Bueller::Commands::BuildGem.run_for(self)
  end

  # Install a previously built gem
  def install_gem
    Bueller::Commands::InstallGem.run_for(self)
  end

  # Bumps the patch version.
  #
  # 1.5.1 -> 1.5.2
  def bump_patch_version()
    Bueller::Commands::Version::BumpPatch.run_for(self)
  end

  # Bumps the minor version.
  #
  # 1.5.1 -> 1.6.0
  def bump_minor_version()
    Bueller::Commands::Version::BumpMinor.run_for(self)
  end

  # Bumps the major version.
  #
  # 1.5.1 -> 2.0.0
  def bump_major_version()
    Bueller::Commands::Version::BumpMajor.run_for(self)
  end

  # Bumps the version, to the specific major/minor/patch version, writing out the appropriate version.rb, and then reloads it.
  def write_version(major, minor, patch, build, options = {})
    command = Bueller::Commands::Version::Write.run_for(self, major, minor, patch, build)
  end

  def release_gem_to_github
    Bueller::Commands::ReleaseToGithub.run_for(self)
  end

  def release_to_git
    Bueller::Commands::ReleaseToGit.run_for(self)
  end

  def release_gem_to_gemcutter
    Bueller::Commands::ReleaseToGemcutter.run_for(self)
  end

  def release_gem_to_rubyforge
    # no-op
  end

  def setup_rubyforge
    # no-op
  end

  def git_base_dir(base_dir = nil)
    if base_dir
      base_dir = File.dirname(base_dir)
    else
      base_dir = File.expand_path(self.base_dir || ".")
    end
    return nil if base_dir==File.dirname("/")
    return base_dir if File.exists?(File.join(base_dir, '.git'))
    git_base_dir(base_dir)
  end    

  def in_git_repo?
    !git_base_dir.nil?
  end

  def version_file_exists?
    File.exists?(@version_helper.plaintext_path) || File.exists?(@version_helper.yaml_path)
  end

  def expects_version_file?
    gemspec.version.nil?
  end
end
