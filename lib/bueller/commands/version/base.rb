require 'pathname'

class Bueller
  module Commands
    module Version
      class Base
        def self.run_for(bueller, major, minor, patch, build)
          command = new bueller, major, minor, patch, build
          command.run
        end

        attr_accessor :version_helper, :gemspec
        attr_reader :bueller

        def initialize(bueller)
          @bueller = bueller
        end

        def version_helper; bueller.version_helper; end
        def gemspec; bueller.gemspec; end

        def run
          update_version

          version_helper.write
          gemspec.version = version_helper.to_s
        end

        def update_version
          raise "Subclasses should implement this"
        end
      end
    end
  end
end
