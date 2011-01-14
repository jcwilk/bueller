class Bueller
  module Commands
    class InstallGem
      def self.run_for(bueller)
        command = new bueller
        command.run
        command
      end

      attr_reader :bueller

      def initialize(bueller)
        @bueller = bueller
        bueller.output = $stdout
      end

      def output
        bueller.output
      end
      def gemspec_helper
        bueller.gemspec_helper
      end

      def run
        command = "#{gem_command} install #{gemspec_helper.gem_path}"
        output.puts "Executing #{command.inspect}:"

        sh command
      end

      def gem_command
        "bundle exec gem"
      end
    end
  end
end
