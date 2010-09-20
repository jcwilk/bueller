require 'spec_helper'

describe Bueller::Generator do
  let(:options) do
    { :project_name => 'the-perfect-gem',
                            :user_name => 'John Doe',
                            :user_email => 'john@example.com',
                            :github_username => 'johndoe',
                            :github_token => 'yyz',
                            :documentation_framework => :rdoc,
                            :testing_framework => :rspec }
  end
  let(:generator) do
    Bueller::Generator.new options
  end

  it "should have the correct constant name" do
    generator.constant_name.should == "ThePerfectGem"
  end

  it "should have the correct file name prefix" do
    generator.file_name_prefix.should == "the_perfect_gem"
  end

  it "should have the correct require name" do
    generator.require_name.should == "the-perfect-gem"
  end

  it "should have the correct lib file name" do
    generator.lib_filename.should == "the-perfect-gem.rb"
  end
  
  it "should have the correct git-remote" do
    generator.git_remote.should == 'git@github.com:johndoe/the-perfect-gem.git'
    generator.git_remote = 'user@host:/path/to/repo'
    generator.git_remote.should == 'user@host:/path/to/repo'
  end

  it 'should set up a project using shoulda' do
    generator = Bueller::Generator.new options.merge(:testing_framework => :shoulda) 
    generator.test_task.should == 'test'
    generator.test_dir.should == 'test'
    generator.default_task.should == 'test'
    generator.feature_support_require.should == 'test/unit/assertions'
    generator.feature_support_extend.should == 'Test::Unit::Assertions'
    generator.test_pattern.should == 'test/**/test_*.rb'
    generator.test_filename.should == 'test_the-perfect-gem.rb'
    generator.test_helper_filename.should == 'helper.rb'
  end

  it 'should create a project using testunit' do
    generator = Bueller::Generator.new options.merge(:testing_framework => :testunit) 
    generator.test_task.should == 'test'
    generator.test_dir.should == 'test'
    generator.default_task.should == 'test'
    generator.feature_support_require.should == 'test/unit/assertions'
    generator.feature_support_extend.should == 'Test::Unit::Assertions'
    generator.test_pattern.should == 'test/**/test_*.rb'
    generator.test_filename.should == 'test_the-perfect-gem.rb'
    generator.test_helper_filename.should == 'helper.rb'
  end

  it 'should create a project using minitest' do
    generator = Bueller::Generator.new options.merge(:testing_framework => :minitest) 
    generator.test_task.should == 'test'
    generator.test_dir.should == 'test'
    generator.default_task.should == 'test'
    generator.feature_support_require.should == 'minitest/unit'
    generator.feature_support_extend.should == 'MiniTest::Assertions'
    generator.test_pattern.should == 'test/**/test_*.rb'
    generator.test_filename.should == 'test_the-perfect-gem.rb'
    generator.test_helper_filename.should == 'helper.rb'
  end

  it 'should create a project using bacon' do
    generator = Bueller::Generator.new options.merge(:testing_framework => :bacon) 
    generator.test_task.should == 'spec'
    generator.test_dir.should == 'spec'
    generator.default_task.should == 'spec'
    generator.feature_support_require.should == 'test/unit/assertions'
    generator.feature_support_extend.should == 'Test::Unit::Assertions'
    generator.test_pattern.should == 'spec/**/*_spec.rb'
    generator.test_filename.should == 'the-perfect-gem_spec.rb'
    generator.test_helper_filename.should == 'spec_helper.rb'
  end

  it 'should create a project using rspec' do
    generator = Bueller::Generator.new options.merge(:testing_framework => :rspec) 
    generator.test_task.should == 'spec'
    generator.test_dir.should == 'spec'
    generator.default_task.should == 'spec'
    generator.feature_support_require.should == 'spec/expectations'
    generator.feature_support_extend.should == nil
    generator.test_pattern.should == 'spec/**/*_spec.rb'
    generator.test_filename.should == 'the-perfect-gem_spec.rb'
    generator.test_helper_filename.should == 'spec_helper.rb'
  end

  it 'should create a project using micronaut' do
    generator = Bueller::Generator.new options.merge(:testing_framework => :micronaut) 
    generator.test_task.should == 'examples'
    generator.test_dir.should == 'examples'
    generator.default_task.should == 'examples'
    generator.feature_support_require.should == 'micronaut/expectations'
    generator.feature_support_extend.should == 'Micronaut::Matchers'
    generator.test_pattern.should == 'examples/**/*_example.rb'
    generator.test_filename.should == 'the-perfect-gem_example.rb'
    generator.test_helper_filename.should == 'example_helper.rb'
  end
  
  it 'should create a project using testspec' do
    generator = Bueller::Generator.new options.merge(:testing_framework => :testspec) 
    generator.test_task.should == 'test'
    generator.test_dir.should == 'test'
    generator.default_task.should == 'test'
    generator.feature_support_require.should == 'test/unit/assertions'
    generator.feature_support_extend.should == 'Test::Unit::Assertions'
    generator.test_pattern.should == 'test/**/*_test.rb'
    generator.test_filename.should == 'the-perfect-gem_test.rb'
    generator.test_helper_filename.should == 'test_helper.rb'
  end
end
