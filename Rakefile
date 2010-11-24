require 'bundler'
begin
  Bundler.setup(:runtime, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift('lib')

require 'bueller'
Bueller::Tasks.new

Bueller::GemcutterTasks.new

Bueller::RubyforgeTasks.new do |t|
  t.doc_task = :yardoc
end


require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/**/test_*.rb') do |list|
    list.exclude 'test/test_helper.rb'
  end
  test.libs << 'test'
  test.verbose = true
end

require 'yard'
YARD::Rake::YardocTask.new(:yardoc) do |t|
  t.files   = FileList['lib/**/*.rb'].exclude('lib/bueller/templates/**/*.rb')
end

require 'rcov/rcovtask'
Rcov::RcovTask.new(:rcov) do |rcov|
  rcov.libs << 'spec'
  rcov.pattern = 'spec/**/*_spec.rb'
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
