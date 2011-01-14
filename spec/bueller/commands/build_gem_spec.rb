require 'spec_helper'

describe Bueller::Commands::BuildGem do
  let(:bueller) { Bueller.new }
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
