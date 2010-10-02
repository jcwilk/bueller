require 'spec_helper'

describe Bueller do
  let(:gemspec) { Gemspec.build }
  let(:bueller_with_git) { Bueller.new(gemspec, git_dir_path) }
  let(:bueller_without_git) { Bueller.new(gemspec, non_git_dir_path) }
  let(:bueller) { Bueller.new(gemspec, git_dir_path) }
  let(:git_dir_path) { File.join(FileSystem.tmp_dir, 'git') }
  let(:non_git_dir_path) { File.join(FileSystem.tmp_dir, 'nongit') }

  describe '#in_git_repo?' do
    it 'should return true if it is in a git repo' do
      FileUtils.mkdir_p git_dir_path
      Dir.chdir git_dir_path do
        Git.init
      end
      bueller_with_git.should be_in_git_repo
    end
    it 'should return false if it is not in a git repo' do
      FileUtils.mkdir_p non_git_dir_path
      bueller_without_git.should_not be_in_git_repo
    end
  end

  describe '#git_base_dir' do
    it 'should find the base repo' do
      bueller = Bueller.new(gemspec, File.dirname(File.expand_path(__FILE__)))
      bueller.git_base_dir.should == File.dirname(File.dirname(File.expand_path(__FILE__)))
    end
  end

  describe '#write_gemspec' do
    it 'should build and run write gemspec command when writing gemspec' do
      Bueller::Commands::WriteGemspec.should_receive(:run_for).with(bueller)

      bueller.write_gemspec
    end
  end

  describe '#validate_gemspec' do
    it 'should build and run validate gemspec command when validating gemspec' do
      Bueller::Commands::ValidateGemspec.should_receive(:run_for).with(bueller)

      bueller.validate_gemspec
    end
  end

  describe '#build_gem' do
    it 'should build and run build gem command when building gem' do
      Bueller::Commands::BuildGem.should_receive(:run_for).with(bueller)

      bueller.build_gem
    end
  end

  describe '#install_gem' do
    it 'should build and run build gem command when installing gem' do
      Bueller::Commands::InstallGem.should_receive(:run_for).with(bueller)

      bueller.install_gem
    end
  end

  describe '#bump_major_version' do
    it 'should build and run bump major version command when bumping major version' do
      Bueller::Commands::Version::BumpMajor.should_receive(:run_for).with(bueller)

      bueller.bump_major_version
    end
  end

  describe '#bump_major_version' do
    it 'should build and run bump minor version command when bumping minor version' do
      Bueller::Commands::Version::BumpMinor.should_receive(:run_for).with(bueller)

      bueller.bump_minor_version
    end
  end

  describe '#bump_major_version' do
    it 'should build and run write version command when writing version' do
      Bueller::Commands::Version::Write.should_receive(:run_for).with(bueller, 1, 5, 2, 'a1')

      bueller.write_version(1, 5, 2, 'a1')
    end
  end

  describe '#bump_major_version' do
    it 'should build and run release to github command when running release_gem_to_github' do
      Bueller::Commands::ReleaseToGithub.should_receive(:run_for).with(bueller)

      bueller.release_gem_to_github
    end
  end

  describe '#bump_major_version' do
    it 'should build and tag the release' do
      Bueller::Commands::GitTagRelease.should_receive(:run_for).with(bueller)

      bueller.git_tag_release
    end
  end
end
