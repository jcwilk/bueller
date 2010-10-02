require 'spec_helper'

describe Bueller::Commands::BuildGem do
  let(:gemspec) do
    g = Gemspec.build
    g.file_name = 'zomg-1.2.3.gem'
  end
  let(:bueller) { Bueller.new Gemspec.build }
  let(:command) { Bueller::Commands::BuildGem.new bueller }

  describe '#run' do
    it 'should make the gem' do
      command.should_receive :make_package_directory
      command.run
    end

    it 'should move the gem into the package directory' do
      command.should_receive :move_gem_file
      command.run
    end
  end

  describe '#gemspec' do
    before do
      command.gemspec_helper.stub! :parse
    end
    it 'should update the version of gemspec helper if the gemspec does not have a version' do
      command.gemspec_helper.stub!(:has_version?).and_return false
      command.gemspec_helper.should_receive :update_version
      command.gemspec
    end
    it 'should not update the version of gemspec helper if the gemspec has a version' do
      command.gemspec_helper.stub!(:has_version?).and_return true
      command.gemspec_helper.should_not_receive :update_version
      command.gemspec
    end
  end

  describe '#base_dir' do
    it "should delegate to bueller" do
      command.base_dir.should == '.'
    end
  end

  describe '#gemspec_helper' do
    it "should delegate to bueller" do
      command.gemspec_helper.should == bueller.gemspec_helper
    end
  end

  describe '#make_package_directory' do
    it 'should make a package directory' do
      command = Bueller::Commands::BuildGem.new bueller
      FileUtils.should_receive(:mkdir_p).with './pkg'
      command.make_package_directory
    end
  end
end
