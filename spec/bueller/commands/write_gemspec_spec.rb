require 'spec_helper'

describe Bueller::Commands::WriteGemspec do
  context "after run" do
    before :each do
      @gemspec = Gem::Specification.new {|s| s.name = 'zomg' }
      @gemspec_helper = Object.new
      @gemspec_helper.stub!(:spec).and_return @gemspec
      @gemspec_helper.stub!(:path).and_return 'zomg.gemspec'
      @gemspec_helper.stub!(:write)

      @output = StringIO.new

      @version_helper = Object.new
      @version_helper.stub!(:to_s).and_return '1.2.3'
      @version_helper.stub!(:refresh)

      @command = Bueller::Commands::WriteGemspec.new
      @command.base_dir = 'tmp'
      @command.version_helper = @version_helper
      @command.gemspec = @gemspec
      @command.output = @output
      @command.gemspec_helper = @gemspec_helper

      @now = Time.now
      Time.stub!(:now).and_return @now
    end

    it "should refresh version" do
      @version_helper.should_receive(:refresh)
      @command.run
    end

    it "should update gemspec version" do
      @command.run
      @gemspec.version.to_s.should == '1.2.3'
    end

    it "should not refresh version neither update version if it's set on the gemspec" do
      @gemspec.version = '2.3.4'
      @command.run
      @gemspec.version.to_s.should == '2.3.4'
    end

    it "should update gemspec date to the beginning of today" do
      @command.run
      @gemspec.date.should == Time.mktime(@now.year, @now.month, @now.day, 0, 0)
    end

    it "should write gemspec" do
      @gemspec_helper.should_receive :write
      @command.run
    end

    it "should output that the gemspec was written" do
      @command.run
      @output.string.should =~ /Generated: zomg\.gemspec/
    end

  end

  BuildCommand.context self, "building for bueller" do
    before :each do
      @gemspec = Gem::Specification.new {|s| s.name = 'zomg' }
      bueller = Bueller.new @gemspec
      @command = Bueller::Commands::WriteGemspec.run_for(bueller)
    end

    it "should return WriteGemspec" do
      @command.should be_a_kind_of Bueller::Commands::WriteGemspec
    end
  end
end
