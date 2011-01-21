class Bueller
  module Commands
    class GitTagRelease
      def self.run_for(bueller)
        command = new bueller
        command.run
        command
      end

      attr_accessor :repo, :output
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
          output.puts "There are some modified files that haven't been committed. Proceed anyway?"
          run = $stdin.gets =~ /(y|yes)/i ? true : false
        end

        if run
          repo.checkout('master')
          
          unless release_tagged?
            output.puts "Tagging #{release_tag}"
            repo.add_tag release_tag
          end
          output.puts "Pushing #{release_tag} to origin"
          repo.push 'origin', release_tag
        else
          raise "Release cancelled"
        end
      end 

      def clean_staging_area?
        status.added.empty? && status.deleted.empty? && status.changed.empty?
      end

      def status
        repo.status
      end

      def release_tag
        "v#{version}"
      end

      def release_tagged?
        begin
          repo.tag(release_tag)
          true
        rescue 
          false
        end
      end
    end
  end
end
