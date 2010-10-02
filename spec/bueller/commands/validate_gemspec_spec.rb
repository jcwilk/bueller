require 'spec_helper'

describe Bueller::Commands::ValidateGemspec do
  let(:bueller) { Bueller.new Gemspec.build }
  let(:command) { Bueller::Commands::ValidateGemspec.build_for(bueller) }

  describe '#gemspec_helper' do
    it "should assign gemspec_helper" do
      command.gemspec_helper.should_not be_nil
    end
  end

  describe '#output' do
    it "should assign output" do
      command.output.should_not be_nil
    end
  end
end
