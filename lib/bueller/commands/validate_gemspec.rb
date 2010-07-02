class Bueller
  module Commands
    class ValidateGemspec
      attr_accessor :gemspec_helper, :output

      def initialize
        self.output = $stdout
      end

      def run
        begin
          gemspec_helper.parse
          output.puts "#{gemspec_helper.path} is valid."
        rescue Exception => e
          output.puts "#{gemspec_helper.path} is invalid. See the backtrace for more details."
          raise
        end
      end

      def self.build_for(bueller)
        command = new

        command.gemspec_helper = bueller.gemspec_helper
        command.output = bueller.output

        command
      end
    end
  end
end
