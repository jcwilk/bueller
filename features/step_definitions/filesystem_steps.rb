Given 'a working directory' do
  @working_dir = create_construct
end

After do
  @working_dir.destroy! if @working_dir
end

Given /^I use the bueller command to generate the "([^"]+)" project in the working directory$/ do |name|
  @name = name

  return_to = Dir.pwd
  path_to_bueller = File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'bin', 'bueller')

  begin
    FileUtils.cd @working_dir
    @stdout = `#{path_to_bueller} #{@name}`
  ensure
    FileUtils.cd return_to
  end
end

Given /^"([^"]+)" does not exist$/ do |file|
  assert ! File.exists?(File.join(@working_dir, file))
end

When /^I run "([^"]+)" in "([^"]+)"$/ do |command, directory|
  full_path = File.join(@working_dir, directory)

  lib_path = File.expand_path 'lib'
  command.gsub!(/^rake /, "rake --trace -I#{lib_path} ")

  File.directory?(full_path).should be_true

  @stdout = `cd #{full_path} && #{command}`
  @exited_cleanly = $?.exited?
end

Then /^the updated version, (.*), is displayed$/ do |version|
  @stdout.should =~ /Updated version: #{version}/
end

Then /^the current version, (\d+\.\d+\.\d+), is displayed$/ do |version|
  @stdout.should =~ /Current version: #{version}/
end

Then /^the process should exit cleanly$/ do
  @exited_cleanly.should be_true # "Process did not exit cleanly: #{@stdout}"
end

Then /^the process should not exit cleanly$/ do
  @exited_cleanly.should be_true # "Process did exit cleanly: #{@stdout}"
end

Given /^I use the existing project "([^"]+)" as a template$/ do |fixture_project|
  @name = fixture_project
  FileUtils.cp_r File.join(fixture_dir, fixture_project), @working_dir
end
