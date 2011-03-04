require 'spec_helper'

describe Bueller::Commands::WriteGemspec do
  let(:bueller) { Bueller.new FileSystem.fixture_path('existing-project') }
  let(:command) { Bueller::Commands::WriteGemspec.new(bueller) }
  let(:now) { Time.now }

  context "after run" do
    before :each do
      bueller.gemspec_helper.stub!(:write)
      bueller.gemspec_helper.stub!(:reload_spec)
      Time.stub!(:now).and_return Time.parse('2011-01-13 04:22:33')
    end
    it "updates the gemspec date to the beginning of today" do
      command.run
      bueller.gemspec_helper.spec_source.should =~ /2011-01-13/
    end
    it "should write gemspec" do
      bueller.gemspec_helper.should_receive :write
      command.run
    end
    it "should output that the gemspec was written" do
      bueller.output = StringIO.new
      command.run
      bueller.output.string.should =~ /Generated: .*existing-project\.gemspec/
    end
  end
end
