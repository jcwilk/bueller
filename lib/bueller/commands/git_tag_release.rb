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
      def gemspec; bueller.gemspec; end
      def gemspec_helper; bueller.gemspec_helper; end
      def version; bueller.version; end
      def repo; bueller.repo; end

      def run
        raise "Hey buddy, try committing them files first" unless clean_staging_area?

        repo.checkout('master')
        repo.push
        
        unless release_tagged?
          output.puts "Tagging #{release_tag}"
          repo.add_tag(release_tag)

          output.puts "Pushing #{release_tag} to origin"
          repo.push('origin', release_tag)
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
          false
        rescue 
          true
        end
      end
    end
  end
end
