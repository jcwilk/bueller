require 'spec_helper'

describe Bueller::Commands::WriteGemspec do
  let(:version_helper) { mock(Object) }
  let(:gemspec_helper) { mock(Object) }
  let(:gemspec) { Gem::Specification.new {|s| s.name = 'zomg' } }
  let(:bueller) { Bueller.new(gemspec) }
  let(:command) { Bueller::Commands::WriteGemspec.new(bueller) }
  let(:now) { Time.now }

  context "after run" do
    before :each do
      gemspec_helper.stub!(:spec).and_return gemspec
      gemspec_helper.stub!(:path).and_return 'zomg.gemspec'
      gemspec_helper.stub!(:write)
      bueller.gemspec_helper = gemspec_helper

      version_helper.stub!(:to_s).and_return '1.2.3'
      bueller.version_helper = version_helper

      Time.stub!(:now).and_return now
    end

    it "should update gemspec version" do
      command.run
      gemspec.version.to_s.should == '1.2.3'
    end

    it "should not refresh version neither update version if it's set on the gemspec" do
      gemspec.version = '2.3.4'
      command.run
      gemspec.version.to_s.should == '2.3.4'
    end

    it "should update gemspec date to the beginning of today" do
      command.run
      gemspec.date.should == Time.mktime(now.year, now.month, now.day, 0, 0)
    end

    it "should write gemspec" do
      gemspec_helper.should_receive :write
      command.run
    end

    it "should output that the gemspec was written" do
      bueller.output = StringIO.new
      command.run
      bueller.output.string.should =~ /Generated: zomg\.gemspec/
    end
  end

  it "should return WriteGemspec" do
    command.should be_a_kind_of Bueller::Commands::WriteGemspec
  end
end
