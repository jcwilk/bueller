require 'spec_helper'
require 'time'

describe Bueller::GemSpecHelper do
  let(:spec) { Gemspec.build }
  let(:helper) { Bueller::GemSpecHelper.new('.') }

  describe "#write" do
    it 'should include updates made to the gemspec' do
      file = mock(File)
      File.stub!(:open).and_yield file
      Time.stub!(:now).and_return Time.parse('2011-03-02 23:33:03')
      helper.set_date
      file.should_receive(:puts).with(/2011-03-02/)
      helper.write
    end
  end

  describe '#path' do
    it 'should return the path to the gemspec' do
      Dir.stub!(:glob).and_return [File.join(File.dirname(__FILE__), 'test.gemspec')]
      helper.path.should == "spec/bueller/test.gemspec"
    end
  end
end
