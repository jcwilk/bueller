require 'spec_helper'

describe Bueller::Generator::Application do
  before :each do
#    opts = {}
#    opts.stub!(:opts).and_return({})
#    Bueller::Generator::Options.stub!(:new).and_return(opts)
  end

  context "when options indicate help usage" do
    let(:application) { App.run_application('-h') }

    it "should exit with code 1" do
      application.should == 1
    end

    it 'should should puts option usage' do
      application
      App.stderr.should =~ /Usage:/
    end

    it 'should not display anything on stdout' do
      application
      App.stdout.squeeze.strip.should == ''
    end
  end

  context "when options indicate an invalid argument" do
    let(:application) { App.run_application('--invalid-argument') }

    it "should exit with code 1" do
      application.should == 1
    end

    it 'should display invalid argument' do
      application
      App.stderr.should =~ /--invalid-argument/
    end

    it 'should display usage on stderr' do
      application
      App.stderr.should =~ /Usage:/
    end

    it 'should not display anything on stdout' do
      App.stdout.squeeze.strip.should == ''
    end
  end

  context "when options are good" do
    let(:application) { App.run_application 'foo' }

    before :each do
      Bueller::Generator.stub!(:run)
    end

    it "should exit with code 1" do
      application.should == 0
    end

    it "should run generator" do
      Bueller::Generator.should_receive :run
      application
    end
  end

end
