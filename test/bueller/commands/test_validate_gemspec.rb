require 'spec_helper'

describe Bueller::Commands::ValidateGemspec do
  BuildCommand.context "build context" do
    before :each do
      @command = Bueller::Commands::ValidateGemspec.build_for(@bueller)
    end

    should "assign gemspec_helper" do
      assert_same @gemspec_helper, @command.gemspec_helper
    end

    should "assign output" do
      assert_same @output, @command.output
    end

    should "return Bueller::Commands::ValidateGemspec" do
      assert_kind_of Bueller::Commands::ValidateGemspec, @command
    end
  end
end
