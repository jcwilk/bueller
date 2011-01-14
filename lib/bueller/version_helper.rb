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

    def parse_version
      # http://rubular.com/regexes/10467 -> 3.5.4.a1
      # http://rubular.com/regexes/10468 -> 3.5.4
      raise VersionMissing unless gemspec_helper.has_version?
      if gemspec_helper.version.to_s =~ /^(\d+)\.(\d+)\.(\d+)(?:\.(.*?))?$/
        @major = $1.to_i
        @minor = $2.to_i
        @patch = $3.to_i
        @build = $4
      else
        raise MalformattedVersion, "Version doesn't match expected format: #{gemspec_helper.version}"
      end
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
