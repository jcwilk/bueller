require 'spec_helper'

describe Bueller::Commands::ReleaseToGemcutter do
  let(:gemspec_helper) { mock(Bueller::GemSpecHelper) }
  let(:bueller) { mock(Bueller, :gemspec_helper => gemspec_helper) }
  let(:command) { Bueller::Commands::ReleaseToGemcutter.new bueller }

  describe '.run' do
    it "should push to gemcutter" do
      command.gemspec_helper.stub!(:gem_path).and_return 'pkg/zomg-1.2.3.gem'
      command.should_receive(:sh).with "bundle exec gem push pkg/zomg-1.2.3.gem"
      command.run
    end
  end
end
