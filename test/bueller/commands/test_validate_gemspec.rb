require 'test_helper'

class Bueller
  module Commands
    class TestValidateGemspec < Test::Unit::TestCase

      BuildCommand.context "build context" do
        setup do
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
  end
end
