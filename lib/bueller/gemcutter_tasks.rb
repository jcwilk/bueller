require 'rake'
require 'rake/tasklib'

class Bueller
  # (Now deprecated) Rake tasks for putting a Bueller gem on Gemcutter. It is part of Bueller::Tasks now.
  class GemcutterTasks < ::Rake::TaskLib
    def initialize
      $stderr.puts "DEPRECATION: gemcutter tasks are now part of Bueller::Tasks. Please remove Bueller::GemcutterTasks at #{caller[1]}"
    end
  end
end
