require 'spec_helper'

describe Bueller::Commands::ReleaseToGemcutter do
  let(:bueller) { Bueller.new Gemspec.build }
  let(:command) { Bueller::Commands::ReleaseToGemcutter.new bueller }

  it "should push to gemcutter" do
    command.gemspec_helper.stub!(:gem_path).and_return 'pkg/zomg-1.2.3.gem'
    command.should_receive(:sh).with "bundle exec gem push pkg/zomg-1.2.3.gem"
    command.run
  end
end
