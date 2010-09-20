require 'spec_helper'

describe Bueller::Generator::Options do
  before :each do
    GitSupport.stub_config GitSupport.valid_config
  end

  def self.should_have_docmentation_framework(documentation_framework)
    it "should use #{documentation_framework} for documentation" do
      @options[:documentation_framework].should == documentation_framework.to_sym
    end
  end

  def setup_options(*arguments)
    @options = Bueller::Generator::Options.new(["project_name"] + arguments)
  end

  def self.for_options(*options)
  end

  context "default options" do
    before(:each) { setup_options }
    should_have_docmentation_framework :rdoc

    it "should use shoulda for testing" do
      options = Bueller::Generator::Options.new(['project_name', '--shoulda'])
      options[:testing_framework].should == :shoulda
    end

    it 'should not create repository' do
      @options[:create_repo].should be_nil
    end

    it "should have project name" do
      @options[:project_name].should == "project_name"
    end

    it "should use github username from git config" do
      @options[:github_username].should == GitSupport.github_user
    end

    it "should use github token from git config" do
      @options[:github_token].should == GitSupport.github_token
    end

    it "should use user name from git config" do
      @options[:user_name].should == GitSupport.name
    end

    it "should use user email from git config" do
      @options[:user_email].should == GitSupport.email
    end
  end


  it "should use bacon for testing" do
    options = Bueller::Generator::Options.new(['project_name', '--bacon'])
    options[:testing_framework].should == :bacon
  end

  it "should use micronaut for testing" do
    options = Bueller::Generator::Options.new(['project_name', '--micronaut'])
    options[:testing_framework].should == :micronaut
  end

  it "should use minitest for testing" do
    options = Bueller::Generator::Options.new(['project_name', '--minitest'])
    options[:testing_framework].should == :minitest
  end

  it "should use rspec for testing" do
    options = Bueller::Generator::Options.new(['project_name', '--rspec'])
    options[:testing_framework].should == :rspec
  end

  it "should use shoulda for testing" do
    options = Bueller::Generator::Options.new(['project_name', '--shoulda'])
    options[:testing_framework].should == :shoulda
  end

  it "should use testunit for testing" do
    options = Bueller::Generator::Options.new(['project_name', '--testunit'])
    options[:testing_framework].should == :testunit
  end

  it "should use testspec for testing" do
    options = Bueller::Generator::Options.new(['project_name', '--testspec'])
    options[:testing_framework].should == :testspec
  end

  it "should use cucumber for testing" do
    options = Bueller::Generator::Options.new(['project_name', '--cucumber'])
    options[:use_cucumber].should be_true
  end

  it "should use reek" do
    options = Bueller::Generator::Options.new(['project_name', '--reek'])
    options[:use_reek].should be_true
  end

  it "should use roodi" do
    options = Bueller::Generator::Options.new(['project_name', '--roodi'])
    options[:use_roodi].should be_true
  end

  for_options '--create-repo' do
    it 'should create repository' do
      @options[:create_repo].should_not be_nil
    end
  end

  for_options '--rdoc' do
    should_have_docmentation_framework :rdoc
  end

  for_options '--yard' do
    should_have_docmentation_framework :yard
  end

  for_options '--summary', 'zomg so awesome' do
    it 'should have summary zomg so awesome' do
      @options[:summary].should == 'zomg so awesome'
    end
  end

  for_options '--description', 'Descriptive' do
    it 'should have description Descriptive' do
      @options[:description].should == 'Descriptive'
    end
  end

  for_options '--directory', 'foo' do
    it 'should have directory foo' do
      @options[:directory].should == 'foo'
    end
  end

  for_options '--help' do
    it 'should show help' do
      @options[:show_help].should_not be_nil
    end
  end

  for_options '-h' do
    it 'should show help' do
      @options[:show_help].should_not be_nil
    end
  end

  for_options '--zomg-invalid' do
    it 'should be an invalid argument' do
      @options[:invalid_argument].should_not be_nil
    end
  end

  for_options '--user-name', 'myname' do
    it "should set user name" do
      @options[:user_name].should == 'myname'
    end
  end

  for_options '--user-email', 'myname@mydomain.com' do
    it "should set user email" do
      @options[:user_email].should == 'myname@mydomain.com'
    end
  end

  for_options '--homepage', 'http://zomg.com' do
    it 'should set hoempage' do
      @options[:homepage].should == 'http://zomg.com'
    end
  end

  for_options '--git-remote', 'git@my-awesome-domain.com:zomg.git' do
    it 'should set the git remote' do
      @options[:git_remote].should == 'git@my-awesome-domain.com:zomg.git'
    end
  end

  for_options '--github-username', 'mygithub' do
    it "should set github username" do
      @options[:github_username].should == 'mygithub'
    end
  end

  for_options '--github-token', 'mygithubtoken' do
    it "should set github token" do
      @options[:github_token].should == 'mygithubtoken'
    end
  end

  context "merging options" do
    it "should take options from each" do
      options = Bueller::Generator::Options.new(["--rspec"]).
        merge Bueller::Generator::Options.new(["--create-repo"])
      options[:testing_framework].should == :rspec
      options[:create_repo].should_not be_nil
    end

    it "should shadow options" do
      options = Bueller::Generator::Options.new(["--bacon"]).
        merge Bueller::Generator::Options.new(["--rspec"])
      options[:testing_framework].should == :rspec
    end
  end
end
