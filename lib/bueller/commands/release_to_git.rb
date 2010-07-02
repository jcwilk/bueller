class Bueller
  module Commands
    class ReleaseToGit
      attr_accessor :gemspec, :version, :repo, :output, :gemspec_helper, :base_dir

      def initialize(attributes = {})
        self.output = $stdout

        attributes.each_pair do |key, value|
          send("#{key}=", value)
        end
      end

      def run
        raise "Hey buddy, try committing them files first" unless clean_staging_area?

        repo.checkout('master')
        repo.push
        
        if release_not_tagged?
          output.puts "Tagging #{release_tag}"
          repo.add_tag(release_tag)

          output.puts "Pushing #{release_tag} to origin"
          repo.push('origin', release_tag)
        end
      end

      def clean_staging_area?
        status = repo.status
        status.added.empty? && status.deleted.empty? && status.changed.empty?
      end

      def release_tag
        "v#{version}"
      end

      def release_not_tagged?
        tag = repo.tag(release_tag) rescue nil
        tag.nil?
      end

      def self.build_for(bueller)
        command = self.new

        command.base_dir = bueller.base_dir
        command.gemspec = bueller.gemspec
        command.version = bueller.version
        command.repo = bueller.repo
        command.output = bueller.output
        command.gemspec_helper = bueller.gemspec_helper

        command
      end
    end
  end
end
