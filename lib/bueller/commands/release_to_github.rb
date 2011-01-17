class Bueller
  module Commands
    class ReleaseToGithub
      def self.run_for(bueller, attributes = {})
        command = new bueller, attributes
        command.run
        command
      end

      attr_accessor :output
      attr_reader :bueller

      def initialize(bueller, attributes = {})
        self.output = $stdout
        @bueller = bueller

        attributes.each_pair do |key, value|
          send("#{key}=", value)
        end
      end

      def base_dir; bueller.base_dir; end
      def version; bueller.version; end
      def repo; bueller.repo; end

      def run
        run = true
        unless clean_staging_area?
          puts "There are some modified files that haven't been committed. Proceed anyway?"
          run = $stdin.gets =~ /(y|yes)/i ? true : false
        end
        if run
          repo.checkout('master')

          output.puts "Pushing master to origin"
          repo.push
        else
          raise "Release cancelled"
        end
      end

      def clean_staging_area?
        status = repo.status
        status.added.empty? && status.deleted.empty? && status.changed.empty?
      end
    end
  end
end
