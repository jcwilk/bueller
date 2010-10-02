class Bueller
  module Commands
    class BuildGem
      def self.run_for(bueller)
        command = new bueller
        command.run
        command
      end

      attr_reader :bueller

      def initialize(bueller)
        @bueller = bueller
      end

      def base_dir
        bueller.base_dir
      end
      def gemspec_helper
        bueller.gemspec_helper
      end
      def version_helper
        bueller.version_helper
      end

      def run
        make_package_directory
        move_gem_file
      end

      def gemspec
        gemspec_helper.update_version(version_helper) unless gemspec_helper.has_version?
        gemspec_helper.parse
      end

      def make_package_directory
        pkg_dir = File.join(base_dir, 'pkg')
        FileUtils.mkdir_p pkg_dir
      end

      def build_gem
        require 'rubygems/builder'
        gem_file_name = Gem::Builder.new(gemspec).build
      end

      def move_gem_file
        gem_file_name = build_gem
        gem_file_path = File.join(base_dir, gem_file_name)
        FileUtils.mv gem_file_path, pkg_dir
      end
    end
  end
end
