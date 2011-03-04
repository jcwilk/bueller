require 'bundler'
Bundler.setup

require 'bueller'
Bueller::Tasks.new

require 'yard'
YARD::Rake::YardocTask.new(:yardoc) do |t|
  t.files   = FileList['lib/**/*.rb'].exclude('lib/bueller/templates/**/*.rb')
end

require 'rspec/core/rake_task'
desc "Run all examples"
RSpec::Core::RakeTask.new('examples') do |c|
  c.rspec_opts = '-Ispec'
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |features|
  features.cucumber_opts = "features --format progress"
end
namespace :features do
  Cucumber::Rake::Task.new(:pretty_features) do |features|
    features.cucumber_opts = "features --format progress"
  end
end

task :default => [:features, :examples]
