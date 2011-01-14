require 'bundler'
begin
  Bundler.setup
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'bueller'
Bueller::Tasks.new
Bueller::RubyforgeTasks.new do |t|
  t.doc_task = :yardoc
end

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
  Cucumber::Rake::Task.new(:pretty) do |features|
    features.cucumber_opts = "features --format progress"
  end
end

task :default => [:features, :examples]
