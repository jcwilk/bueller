require 'test_helper'

class TestBueller < Test::Unit::TestCase

  def build_bueller(base_dir = nil)
    base_dir ||= git_dir_path
    FileUtils.mkdir_p base_dir

    Bueller.new(build_spec, base_dir)
  end

  def git_dir_path
    File.join(tmp_dir, 'git')
  end

  def non_git_dir_path
    File.join(tmp_dir, 'nongit')
  end

  def build_git_dir

    FileUtils.mkdir_p git_dir_path
    Dir.chdir git_dir_path do
      Git.init
    end
  end

  def build_non_git_dir
    FileUtils.mkdir_p non_git_dir_path
  end

  should "raise an error if a nil gemspec is given" do
    assert_raises Bueller::GemspecError do
      Bueller.new(nil)
    end
  end

  should "know if it is in a git repo" do
    build_git_dir

    assert build_bueller(git_dir_path).in_git_repo?
  end

  should "know if it is not in a git repo" do
    build_non_git_dir

    bueller = build_bueller(non_git_dir_path)
    assert ! bueller.in_git_repo?, "bueller doesn't know that #{bueller.base_dir} is not a git repository"
  end

  should "find the base repo" do
    bueller = build_bueller(File.dirname(File.expand_path(__FILE__)))
    assert_equal File.dirname(File.dirname(File.expand_path(__FILE__))), bueller.git_base_dir
  end

  should "build and run write gemspec command when writing gemspec" do
    bueller = build_bueller

    command = Object.new
    mock(command).run

    mock(Bueller::Commands::WriteGemspec).build_for(bueller) { command }

    bueller.write_gemspec
  end

  should "build and run validate gemspec command when validating gemspec" do
    bueller = build_bueller

    command = Object.new
    mock(command).run

    mock(Bueller::Commands::ValidateGemspec).build_for(bueller) { command }

    bueller.validate_gemspec
  end

  should "build and run build gem command when building gem" do
    bueller = build_bueller

    command = Object.new
    mock(command).run

    mock(Bueller::Commands::BuildGem).build_for(bueller) { command }

    bueller.build_gem
  end

  should "build and run build gem command when installing gem" do
    bueller = build_bueller

    command = Object.new
    mock(command).run

    mock(Bueller::Commands::InstallGem).build_for(bueller) { command }

    bueller.install_gem
  end

  should "build and run bump major version command when bumping major version" do
    bueller = build_bueller

    command = Object.new
    mock(command).run

    mock(Bueller::Commands::Version::BumpMajor).build_for(bueller) { command }

    bueller.bump_major_version
  end

  should "build and run bump minor version command when bumping minor version" do
    bueller = build_bueller

    command = Object.new
    mock(command).run

    mock(Bueller::Commands::Version::BumpMinor).build_for(bueller) { command }

    bueller.bump_minor_version
  end

  should "build and run write version command when writing version" do
    bueller = build_bueller

    command = Object.new
    mock(command).run
    mock(command).major=(1)
    mock(command).minor=(5)
    mock(command).patch=(2)
    mock(command).build=('a1')

    mock(Bueller::Commands::Version::Write).build_for(bueller) { command }

    bueller.write_version(1, 5, 2, 'a1')
  end

  should "build and run release to github command when running release_gem_to_github" do
    bueller = build_bueller

    command = Object.new
    mock(command).run

    mock(Bueller::Commands::ReleaseToGithub).build_for(bueller) { command }

    bueller.release_gem_to_github
  end

  should "build and run release to git command when running release_to_git" do
    bueller = build_bueller

    command = Object.new
    mock(command).run

    mock(Bueller::Commands::ReleaseToGit).build_for(bueller) { command }

    bueller.release_to_git
  end

  should "respond to gemspec_helper" do
    assert_respond_to build_bueller, :gemspec_helper
  end

  should "respond to version_helper" do
    assert_respond_to build_bueller, :version_helper
  end

  should "respond to repo" do
    assert_respond_to build_bueller, :repo
  end

  should "respond to commit" do
    assert_respond_to build_bueller, :commit
  end

end
