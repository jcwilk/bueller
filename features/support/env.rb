require 'bundler'
begin
  Bundler.setup
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'bueller'
require 'output_catcher'
require 'timecop'
require 'active_support'
require 'sandbox'
require 'rspec/expectations'
require 'cucumber/rspec/doubles'

def yank_task_info(content, task)
  if content =~ /#{Regexp.escape(task)}.new(\(.*\))? do \|(.*?)\|(.*?)end/m
    [$2, $3]
  end
end

def yank_group_info(content, group)
  if content =~ /group :#{group} do(.*?)end/m
    $1
  end
end

def fixture_dir
  File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec', 'fixtures')
end

After do
  Timecop.return
end
