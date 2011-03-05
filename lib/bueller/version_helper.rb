require 'yaml'

class Bueller
  class VersionHelper
    class VersionMissing < StandardError; end
    class MalformattedVersion < StandardError; end

    attr_accessor :gemspec_helper
    attr_reader :major, :minor, :patch, :build

    def initialize(gemspec_helper)
      self.gemspec_helper = gemspec_helper
      parse_version
    end

    def path
      File.join(gemspec_helper.base_dir, 'lib', gemspec_helper.project_name, 'version.rb')
    end

    def version_source
      @version_source ||= File.read path
    end

    def parse_version
      if version_source =~ /VERSION[^\d]+(\d+)\.(\d+)\.(\d+)(\.([^'"]*))?/
        @major = $1.to_i
        @minor = $2.to_i
        @patch = $3.to_i
        @build = $5
      else
        raise VersionMissing, "lib/#{gemspec_helper.project_name}/version.rb doesn't contain a version string"
      end
    end

    def write_version
      version_source.sub! /VERSION\s*=.*/, %Q{VERSION = "#{to_s}"}
      File.open(path, 'w') { |f| f.puts version_source }
      parse_version
    end

    def bump_major
      @major += 1
      @minor = 0
      @patch = 0
      @build = nil
    end

    def bump_minor
      @minor += 1
      @patch = 0
      @build = nil
    end

    def bump_patch
      @patch += 1
      @build = nil
    end

    def update_to(major, minor, patch, build=nil)
      @major = major
      @minor = minor
      @patch = patch
      @build = build
    end

    def to_s
      [major, minor, patch, build].compact.join('.')
    end
  end
end
