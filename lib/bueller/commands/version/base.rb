require 'pathname'

class Bueller
  module Commands
    module Version
      class Base
        def self.run_for(bueller)
          command = new bueller
          command.run
          command
        end

        attr_accessor :version_helper, :gemspec
        attr_reader :bueller

        def initialize(bueller)
          @bueller = bueller
        end

        def version_helper; bueller.version_helper; end
        def gemspec_helper; bueller.gemspec_helper; end

        def run
          update_version

          gemspec_helper.update_version version_helper.to_s
          gemspec_helper.write
        end

        def update_version
          raise "Subclasses should implement this"
        end
      end
    end
  end
end
