require 'spec_helper'

describe Bueller::Commands::WriteGemspec do
  let(:version_helper) { mock(Object) }
  let(:gemspec_helper) { mock(Object) }
  let(:bueller) { Bueller.new('crowbar') }
  let(:command) { Bueller::Commands::WriteGemspec.new(bueller) }
  let(:now) { Time.now }

  context "after run" do
    before :each do
      gemspec_helper.stub!(:set_version)
      gemspec_helper.stub!(:set_date)
      gemspec_helper.stub!(:write)
      bueller.gemspec_helper = gemspec_helper

      version_helper.stub!(:to_s).and_return '1.2.3'
      bueller.version_helper = version_helper

      Time.stub!(:now).and_return now
    end

    it "should update gemspec version" do
      gemspec_helper.should_receive(:set_version).with('1.2.3')
      command.run
    end

    it "should update gemspec date to the beginning of today" do
      gemspec_helper.should_receive(:set_date).with(now)
      command.run
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
end
