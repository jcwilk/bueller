require 'spec_helper'

describe Bueller::Commands::InstallGem do
  let(:bueller) { Bueller.new Gemspec.build }
  let(:command) { Bueller::Commands::InstallGem.new bueller }

  it "should call sh with gem install" do
    command.should_receive(:sh).with  'bundle exec gem install ./pkg/bar-0.1.1.gem'
    command.run
  end
end
