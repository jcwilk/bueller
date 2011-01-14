require 'spec_helper'

describe Bueller::Commands::InstallGem do

  it "should call sh with gem install" do
    bueller = Bueller.new FileSystem.fixture_path('existing-project')
    command = Bueller::Commands::InstallGem.new bueller
    command.should_receive(:sh).with /bundle exec gem install .*\/pkg\/existing-project-1.5.3.gem/
    command.run
  end
end
