require 'spec_helper'

describe Bueller::Commands::Version::BumpMinor do
  it "should call bump_minor on version_helper in update_version" do
    bueller = Bueller.new Gemspec.build
    command = Bueller::Commands::Version::BumpMinor.new bueller

    command.update_version

    command.version_helper.minor.should == 2
  end
end
