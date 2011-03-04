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
  let(:generator) { Bueller::Generator.new options }

  describe '#initialize' do
    context "given a nil github repo name" do
      before :each do
        GitSupport.stub_config
      end

      it 'should raise NoGithubRepoNameGiven' do
        pending "don't be so picky"
        assert_raise Bueller::NoGitHubRepoNameGiven do
          Bueller::Generator.new()
        end
      end
    end

    context "without git user's name set" do
      before :each do
        GitSupport.stub_config 
      end

      it 'should raise an NoGitUserName' do
        pending "don't be so picky"
        assert_raise Bueller::NoGitUserName do
          Bueller::Generator.new(:project_name => @project_name, :testing_framework => :shoulda, :documentation_framework => :rdoc)
        end
      end
    end

    context "without git user's email set" do
      before :each do
        GitSupport.stub_config 
      end

      it 'should raise NoGitUserEmail' do
        pending "don't be so picky"
        assert_raise Bueller::NoGitUserEmail do
          Bueller::Generator.new(:project_name => @project_name, :user_name => GitSupport.name, :testing_framework => :shoulda, :documentation_framework => :rdoc)
        end
      end
    end

    context "without github username set" do
      before :each do
        GitSupport.stub_config
      end

      it 'should raise NotGitHubUser' do
        pending "don't be so picky"
        assert_raise Bueller::NoGitHubUser do
          Bueller::Generator.new(:project_name => @project_name, :user_name => GitSupport.name, :user_email => GitSupport.email, :testing_framework => :shoulda, :documentation_framework => :rdoc)
        end
      end
    end
    
    context "without github token set" do
      before :each do
        GitSupport.stub_config
      end

      it 'should raise NoGitHubToken if creating repo' do
        pending "don't be so picky"
        assert_raise Bueller::NoGitHubToken do
          Bueller::Generator.new(:project_name => @project_name, :user_name => GitSupport.name, :user_email => GitSupport.email, :github_username => @github_user, :create_repo => true, :testing_framework => :shoulda, :documentation_framework => :rdoc)
        end
      end
    end

    let(:defaults) do
      defaults = { :project_name => GitSupport.project_name,
                   :user_name => GitSupport.name,
                   :user_email => GitSupport.email,
                   :github_username => GitSupport.github_user,
                   :github_token => GitSupport.github_token,
                   :testing_framework =>       :rspec,
                   :documentation_framework => :rdoc }

    end
    let(:generator) { Bueller::Generator.new(defaults) }

    context "default configuration" do
      before :each do
        GitSupport.stub_config
      end

      it "should use rspec for testing" do
        generator.testing_framework.should == :rspec
      end

      it "should use rdoc for documentation" do
        generator.documentation_framework.should == :rdoc
      end

      it "should set todo in summary" do
        generator.summary.should =~ /todo/i
      end

      it "should set todo in description" do
        generator.description.should =~ /todo/i
      end

      it "should set target directory to the project name" do
        generator.target_dir.should == GitSupport.project_name
      end

      it "should set user's name from git config" do
        generator.user_name.should == GitSupport.name
      end

      it "should set email from git config" do
        generator.user_email.should == GitSupport.email
      end

      it "should set origin remote as github, based on username and project name" do
        generator.git_remote.should == "git@github.com:#{GitSupport.github_user}/#{GitSupport.project_name}.git"
      end

      it "should set homepage as github based on username and project name" do
        generator.homepage.should == "http://github.com/#{GitSupport.github_user}/#{GitSupport.project_name}"
      end

      it "should set github username from git config" do
        generator.github_username.should == GitSupport.github_user
      end

      it "should set project name as the-perfect-gem" do
        generator.project_name.should == GitSupport.project_name
      end
    end

    context "using yard" do
      let(:generator) { Bueller::Generator.new(defaults.merge :documentation_framework => :yard) }

      it "should set the doc_task to yardoc" do
        generator.doc_task.should == "yardoc"
      end

    end

    context "using rdoc" do
      let(:generator) { Bueller::Generator.new(defaults.merge :documentation_framework => :rdoc) }

      it "should set the doc_task to rdoc" do
        generator.doc_task.should == "rdoc"
      end
    end

    context "using a custom homepage" do
      let(:generator) { Bueller::Generator.new(defaults.merge :homepage => 'http://zomg.com') }

      it "should set the homepage" do
        generator.homepage.should == "http://zomg.com"
      end
    end
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
    generator.test_task.should == 'examples'
    generator.test_dir.should == 'spec'
    generator.default_task.should == 'examples'
    generator.feature_support_require.should == 'rspec/expectations'
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

  describe '#output'
end
