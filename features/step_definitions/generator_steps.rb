Given /^I do not want cucumber stories$/ do
  @use_cucumber = false
end

Given /^I want cucumber stories$/ do
  @use_cucumber = true
end

Given /^I do not want reek$/ do
  @use_reek = false
end

Given /^I want reek$/ do
  @use_reek = true
end

Given /^I do not want roodi$/ do
  @use_roodi = false
end

Given /^I want roodi$/ do
  @use_roodi = true
end

Given /^I want to use yard instead of rdoc$/ do
  @documentation_framework = "yard"
end

Given /^I want to use rdoc instead of yard$/ do
  @documentation_framework = "rdoc"
end


Given /^I intend to test with (\w+)$/ do |testing_framework|
  @testing_framework = testing_framework.to_sym
end

Given /^I have configured git sanely$/ do
  @user_email = 'bar@example.com'
  @user_name = 'foo'
  @github_user = 'technicalpickles'
  @github_token = 'zomgtoken'

  require 'git'
  Git.stub!(:global_config).
        and_return({
          'user.name' => @user_name,
          'user.email' => @user_email,
          'github.user' => @github_user,
          'github.token' => @github_token})
end

Given /^I set BUELLER_OPTS env variable to "(.*)"$/ do |val|
  ENV['BUELLER_OPTS'] = val
end

Given /^it is the year (\d+)$/ do |year|
  time = Time.local(year.to_i, 9, 1, 10, 5, 0)
  Timecop.travel(time)
end


When /^I generate a (.*)project named '((?:\w|-|_)+)' that is '([^']*)'$/ do |testing_framework, name, summary|
  When "I generate a #{testing_framework}project named '#{name}' that is '#{summary}' and described as ''"
end

When /^I generate a (.*)project named '((?:\w|-|_)+)' that is '([^']*)' and described as '([^']*)'$/ do |testing_framework, name, summary, description|
  @name = name
  @summary = summary
  @description = description

  testing_framework = testing_framework.squeeze.strip
  unless testing_framework.blank?
    @testing_framework = testing_framework.to_sym
  end


  arguments = ['--directory',
               "#{@working_dir}/#{@name}",
               '--summary', @summary,
               '--description', @description,
                @use_cucumber ? '--cucumber' : nil,
                @testing_framework ? "--#{@testing_framework}" : nil,
                @use_roodi ? '--roodi' : nil,
                @use_reek ? '--reek' : nil,
                @documentation_framework ? "--#{@documentation_framework}" : nil,
                @name].compact

  @stdout = OutputCatcher.catch_out do
    Bueller::Generator::Application.run! *arguments
  end

  @repo = Git.open(File.join(@working_dir, @name))
end

Then /^a directory named '(.*)' is created$/ do |directory|
  directory = File.join(@working_dir, directory)

  File.exists?(directory).should be_true # "#{directory} did not exist"
  File.directory?(directory).should be_true # "#{directory} is not a directory"
end

Then "cucumber directories are created" do
  Then "a directory named 'the-perfect-gem/features' is created"
  Then "a directory named 'the-perfect-gem/features/support' is created"
  Then "a directory named 'the-perfect-gem/features/step_definitions' is created"
end


Then /^a file named '(.*)' is created$/ do |file|
  file = File.join(@working_dir, file)

  File.exists?(file).should be_true #, "#{file} expected to exist, but did not"
  File.file?(file).should be_true # "#{file} expected to be a file, but is not"
end

Then /^a file named '(.*)' is not created$/ do |file|
  file = File.join(@working_dir, file)

  File.exists?(file).should be_false # "#{file} expected to not exist, but did"
end

Then /^a sane '.gitignore' is created$/ do
  Then "a file named 'the-perfect-gem/.gitignore' is created"
  Then "'coverage' is ignored by git"
  Then "'\\*\\.swp' is ignored by git"
  Then "'\\.DS_Store' is ignored by git"
  Then "'rdoc' is ignored by git"
  Then "'pkg' is ignored by git"
end

Then /^'(.*)' is ignored by git$/ do |git_ignore|
  @gitignore_content ||= File.read(File.join(@working_dir, @name, '.gitignore'))

  @gitignore_content.should =~ /#{git_ignore}/
end

Then /^Rakefile has '(.*)' for the (.*) (.*)$/ do |value, task_class, field|
  @rakefile_content ||= File.read(File.join(@working_dir, @name, 'Rakefile'))
  block_variable, task_block = yank_task_info(@rakefile_content, task_class)
  #raise "Found in #{task_class}: #{block_variable.inspect}: #{task_block.inspect}"

  task_block.should =~ /#{block_variable}\.#{field} = (%Q\{|"|')#{Regexp.escape(value)}(\}|"|')/
end

Then /^Rakefile has '(.*)' in the Rcov::RcovTask libs$/ do |libs|
  @rakefile_content ||= File.read(File.join(@working_dir, @name, 'Rakefile'))
  block_variable, task_block = yank_task_info(@rakefile_content, 'Rcov::RcovTask')

  @rakefile_content.should =~ /#{block_variable}\.libs << '#{libs}'/
end


Then /^'(.*)' contains( regex)? '(.*)'$/ do |file, regex, expected_string|
  contents = File.read(File.join(@working_dir, @name, file))
  pattern = regex ? expected_string : Regexp.escape(expected_string)
  contents.should =~ /#{pattern}/
end

Then /^'(.*)' mentions copyright belonging to me in (\d{4})$/ do |file, year|
  Then %Q{'#{file}' contains regex 'Copyright \\(c\\) #{year} #{@user_name}'}
end

Then /^'(.*)' mentions copyright belonging to me in the current year$/ do |file|
  current_year = Time.now.year
  Then "'#{file}' mentions copyright belonging to me in #{current_year}"
end


Then /^LICENSE credits '(.*)'$/ do |copyright_holder|
  Then "a file named 'the-perfect-gem/LICENSE' is created"
  Then "'LICENSE' contains '#{copyright_holder}'"
end

Then /^LICENSE has a copyright in the year (\d+)$/ do |year|
  Then "a file named 'the-perfect-gem/LICENSE' is created"
  Then "'LICENSE' contains '#{year}'"
end


Then /^'(.*)' should define '(.*)' as a subclass of '(.*)'$/ do |file, class_name, superclass_name|
  Then "'#{file}' contains 'class #{class_name} < #{superclass_name}'"
end

Then /^'(.*)' should describe '(.*)'$/ do |file, describe_name|
  Then "'#{file}' contains regex 'describe \"?#{describe_name}\"? do'"
end

Then /^'(.*)' should contextualize '(.*)'$/ do |file, describe_name|
  Then "'#{file}' contains regex 'context \"#{describe_name}\" do'"
end

Then /^'(.*)' should have tests for '(.*)'$/ do |file, describe_name|
  Then %Q{'#{file}' contains 'Shindo.tests("#{describe_name}") do'}
end

Then /^'(.*)' requires '(.*)'$/ do |file, lib|
  Then %Q{'#{file}' contains regex 'require ['"]#{Regexp.escape(lib)}['"]'}
end

Then /^'(.*)' does not require '(.*)'$/ do |file, lib|
  content = File.read(File.join(@working_dir, @name, file))

  content.should_not =~ /require ['"]#{Regexp.escape(lib)}['"]/
end

Then /^Rakefile does not require '(.*)'$/ do |file|
  Then "'Rakefile' does not require '#{file}'"
end

Then /^Rakefile requires '(.*)'$/ do |file|
  Then "'Rakefile' requires '#{file}'"
end

Then /^Rakefile does not instantiate a (.*)$/ do |task_name|
  content = File.read(File.join(@working_dir, @name, 'Rakefile'))
  content.should_not =~ /#{task_name}/
end

Then /^Rakefile instantiates a (.*)$/ do |task_name|
  Then %Q{'Rakefile' contains '#{task_name}'}
end


Then /^'(.+?)' should autorun tests$/ do |test_helper|
  Then %Q{'#{test_helper}' contains 'MiniTest::Unit.autorun'}
end

Then /^cucumber world extends "(.*)"$/ do |module_to_extend|
  Then %Q{'features/support/env.rb' contains 'World\(#{module_to_extend}\)'}
end


Then /^'features\/support\/env\.rb' sets up features to use test\/unit assertions$/ do

end

Then /^'features\/support\/env\.rb' sets up features to use minitest assertions$/ do
  content = File.read(File.join(@working_dir, @name, 'features', 'support', 'env.rb'))

  content.should == "world.extend(Mini::Test::Assertions)"
end

Then /^git repository has '(.*)' remote$/ do |remote|
  remote = @repo.remotes.first

  remote.name.should == 'origin'
end

Then /^git repository '(.*)' remote should be '(.*)'/ do |remote, remote_url|
  remote = @repo.remotes.first

  remote.url.should == 'git@github.com:technicalpickles/the-perfect-gem.git'
end

Then /^a commit with the message '(.*)' is made$/ do |message|
  @repo.log.first.message.should == message
end

Then /^'(.*)' was checked in$/ do |file|
  status = @repo.status[file]

  status.should_not be_nil # "wasn't able to get status for #{file}"
  status.untracked.should be_false # "#{file} was untracked"
  status.type.should be_nil # "#{file} had a type. it should have been nil"
end

Then /^no files are (\w+)$/ do |type|
  @repo.status.send(type).size.should == 0
end

Then /^Rakefile has "(.*)" as the default task$/ do |task|
  @rakefile_content ||= File.read(File.join(@working_dir, @name, 'Rakefile'))
  @rakefile_content.should =~ /task :default => :#{task}/
end


After do
  ENV['BUELLER_OPTS'] = nil
end

Then /^'Gemfile' depends on the gemspec$/ do
  @gemfile_content ||= File.read(File.join(@working_dir, @name, 'Gemfile'))
  @gemfile_content.should =~ /gemspec/
end

Then /^the gemspec has '(.*)' set to '(.*)'$/ do |property, value|
  Then %Q{'the-perfect-gem.gemspec' contains regex '\\.#{property}\\s*=.*['"]#{Regexp.escape(value)}['"]'}
end

Then /^the gemspec has development dependency '(.*)'$/ do |gem|
  Then %Q{'the-perfect-gem.gemspec' contains 'add_development_dependency '#{gem}''}
end
