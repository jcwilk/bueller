require 'spec_helper'

describe Bueller::Commands::Version::BumpPatch do
  it "should call bump_patch on version_helper in update_version" do
    bueller = Bueller.new Gemspec.build
    command = Bueller::Commands::Version::BumpPatch.new bueller

    command.update_version

    command.version_helper.patch.should == 2
  end
end
