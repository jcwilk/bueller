class Bueller
  module Commands
    class WriteGemspec
      attr_accessor :base_dir, :gemspec, :output, :gemspec_helper, :version_helper

      def initialize(bueller)
        self.output = $stdout
        self.base_dir = bueller.base_dir
        self.gemspec = bueller.gemspec
        self.output = bueller.output
        self.gemspec_helper = bueller.gemspec_helper
        self.version_helper = bueller.version_helper
      end

      def run
        gemspec_helper.spec.version ||= version_helper.to_s
        gemspec_helper.spec.date = Time.now
        gemspec_helper.write

        output.puts "Generated: #{gemspec_helper.path}"  
      end

      def gemspec_helper
        @gemspec_helper ||= GemSpecHelper.new(self.gemspec, self.base_dir)
      end

      def self.run_for(bueller)
        command = new(bueller)
        command.run
        command
      end
    end
  end
end
