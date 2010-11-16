require 'spec_helper'

describe Bueller::GemSpecHelper do
  let(:spec) { Gemspec.build }
  let(:helper) { Bueller::GemSpecHelper.new(spec, File.dirname(__FILE__)) }

  describe '#path' do
    it 'should return the path to the gemspec' do
      helper.path.should == "spec/bueller/#{spec.name}.gemspec"
    end
  end

  describe "#write" do
    before :each do
      FileUtils.rm_f(helper.path)

      helper.write
    end
    after :each do
      FileUtils.rm_f(helper.path)
    end

    it "should create gemspec file" do
      File.exists?(helper.path).should be_true
    end

    it "should make valid spec" do
      helper.should be_valid
    end

    it "should parse" do
      helper.parse.should be_an_instance_of(Gem::Specification)
    end
  end
end
