require 'spec_helper'

describe Bueller::Commands::Version::BumpMajor do
  it "should call bump_major on version_helper in update_version" do
    bueller = Bueller.new FileSystem.fixture_path('existing-project')
    command = Bueller::Commands::Version::BumpMajor.new bueller

    command.update_version

    command.version_helper.major.should == 2
  end
end
