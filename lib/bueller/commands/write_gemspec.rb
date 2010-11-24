class Bueller
  module Commands
    class WriteGemspec
      attr_accessor :base_dir, :output, :gemspec_helper, :version_helper

      def initialize(bueller)
        self.output = $stdout
        self.base_dir = bueller.base_dir
        self.output = bueller.output
        self.gemspec_helper = bueller.gemspec_helper
        self.version_helper = bueller.version_helper
      end

      def run
        gemspec_helper.set_version version_helper.to_s
        gemspec_helper.set_date Time.now
        gemspec_helper.write

        output.puts "Generated: #{gemspec_helper.path}"  
      end

      def self.run_for(bueller)
        command = new(bueller)
        command.run
        command
      end
    end
  end
end
