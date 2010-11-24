require 'spec_helper'

describe Bueller::GemSpecHelper do
  let(:spec) { Gemspec.build }
  let(:helper) { Bueller::GemSpecHelper.new('.') }

  describe '#valid?' do
    it 'should return true if the gemspec is valid' do
      helper.should be_valid
    end
    it 'should return false if the gemspec is not valid' do
      helper.stub!(:reload_spec).and_raise StandardError
      helper.should_not be_valid
    end
  end

  describe '#spec_sexp' do
    it 'should load the sexp rendition of a gemspec from the gemspec file' do
      helper.spec_sexp.to_s.include?("s(:str, \"bueller\")").should be_true
    end
  end

  describe '#reload_spec' do
    it 'should reload the gemspec from the sexp' do
      helper.spec_sexp = RubyParser.new.process "2 + 2"
      helper.reload_spec.should == 4
    end
  end

  describe "#write" do
    it 'should include updates made to the gemspec' do
      file = mock(File)
      File.stub!(:open).and_yield file
      helper.update_version '999.999.999'
      file.should_receive(:puts).with(/999\.999\.999/)
      helper.write
    end
  end

  describe '#path' do
    it 'should return the path to the gemspec' do
      Dir.stub!(:glob).and_return [File.join(File.dirname(__FILE__), 'test.gemspec')]
      helper.path.should == "spec/bueller/test.gemspec"
    end
  end

  describe '#update_version' do
    it 'should set the spec version to the new version' do
      helper.update_version '999.999.999'
      helper.version.should == '999.999.999'
    end
    it 'should raise an error if the spec has no existing version' do
      s = Gem::Specification.new
      helper.instance_variable_set :@spec_ruby, s.to_ruby
      expect do
        helper.update_version '9.9.9'
      end.should raise_error(Bueller::GemSpecHelper::VersionMissing)
    end
  end

  describe '#sexp_version' do
    it 'should fetch the sexp node containing the version' do
      node = helper.sexp_version
      puts "NODE"
      puts node.inspect
      node.should be_a_kind_of(RubyParser::Sexp)
      node.last.last.last.should == '0.0.1'
    end
  end
end
