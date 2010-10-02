class Bueller
  module Commands
    class ReleaseToGemcutter
      attr_reader :bueller

      def initialize(bueller)
        @bueller = bueller
      end

      def gemspec; bueller.gemspec; end
      def gemspec_helper; bueller.gemspec_helper; end
      def version; bueller.version; end

      def run
        command = "bundle exec gem push #{gemspec_helper.gem_path}"
        $stdout.puts "Executing #{command.inspect}:"
        sh command
      end

      def self.run_for(bueller)
        command = new bueller
        command.run
        command
      end
    end
  end
end
