require 'spec_helper'

describe Bueller::Commands::Version::BumpPatch do
  it "should call bump_patch on version_helper in update_version" do
    bueller = Bueller.new FileSystem.fixture_path('existing-project')
    command = Bueller::Commands::Version::BumpPatch.new bueller

    command.update_version

    command.version_helper.patch.should == 4
  end
end
