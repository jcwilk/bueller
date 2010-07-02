class Bueller
  module Commands
    class ReleaseToGemcutter
      attr_accessor :gemspec, :version, :output, :gemspec_helper

      def initialize
        self.output = $stdout
      end

      def run
        command = "gem push #{@gemspec_helper.gem_path}"
        output.puts "Executing #{command.inspect}:"
        sh command
      end

      def self.build_for(bueller)
        command = new
        command.gemspec        = bueller.gemspec
        command.gemspec_helper = bueller.gemspec_helper
        command.version        = bueller.version
        command.output         = bueller.output
        command
      end
    end
  end
end
