require 'yaml'

class Bueller
  class VersionHelper
    attr_accessor :gemspec, :gemspec_path
    attr_reader :major, :minor, :patch, :build

    def initialize(gemspec_helper)
      self.gemspec = gemspec_helper.spec
      self.gemspec_path = gemspec_helper.path
      parse_gemspec
    end

    def write
      File.open(gemspec_path, 'w') do |file|
        file.write to_s
      end
    end

    def parse_gemspec
      # http://rubular.com/regexes/10467 -> 3.5.4.a1
      # http://rubular.com/regexes/10468 -> 3.5.4
      if gemspec.version.to_s =~ /^(\d+)\.(\d+)\.(\d+)(?:\.(.*?))?$/
        @major = $1.to_i
        @minor = $2.to_i
        @patch = $3.to_i
        @build = $4
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
