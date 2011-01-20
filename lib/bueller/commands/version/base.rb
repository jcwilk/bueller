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
        def repo; bueller.repo; end
        def commit; bueller.commit; end

        def run
          update_version

          gemspec_helper.update_version version_helper.to_s
          gemspec_helper.set_date
          gemspec_helper.write

          commit_version
        end

        def update_version
          raise "Subclasses should implement this"
        end

        def commit_version
          if repo and commit
            repo.add gemspec_helper.path
            repo.commit "Version bump to #{version_helper.to_s}"
          end
        end
      end
    end
  end
end
