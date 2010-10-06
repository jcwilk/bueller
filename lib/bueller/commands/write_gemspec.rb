class Bueller
  module Commands
    class WriteGemspec
      attr_accessor :base_dir, :gemspec, :version, :output, :gemspec_helper, :version_helper

      def initialize
        self.output = $stdout
      end

      def run
        gemspec_helper.gemspec.version ||= begin
          version_helper.refresh
          version_helper.to_s
        end

        gemspec_helper.gemspec.date    = Time.now
        gemspec_helper.write

        output.puts "Generated: #{gemspec_helper.path}"  
      end

      def gemspec_helper
        @gemspec_helper ||= GemSpecHelper.new(self.gemspec, self.base_dir)
      end

      def self.run_for(bueller)
        command = new

        command.base_dir = bueller.base_dir
        command.gemspec = bueller.gemspec
        command.version = bueller.version
        command.output = bueller.output
        command.gemspec_helper = bueller.gemspec_helper
        command.version_helper = bueller.version_helper

        command
      end
    end
  end
end
