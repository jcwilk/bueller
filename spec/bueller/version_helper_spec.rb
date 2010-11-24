require 'spec_helper'

describe Bueller::VersionHelper do

  let(:gemspec_helper) { mock Bueller::GemSpecHelper }
  let(:helper) { Bueller::VersionHelper.new gemspec_helper }

  describe "full version" do
    before do
      gemspec_helper.stub!(:version).and_return '3.5.4'
    end

    it 'should have version 3.5.4' do
      helper.should have_version(3, 5, 4)
    end

    it "should bump major version" do
      helper.bump_major
      helper.should have_version(4, 0, 0)
    end

    it "should bump the minor version" do
      helper.bump_minor
      helper.should have_version(3, 6, 0)
    end

    it "should bump the patch version" do
      helper.bump_patch
      helper.should have_version(3, 5, 5)
    end
  end

  describe "prerelease version" do
    before do
      gemspec_helper.stub!(:version).and_return '3.5.4.a1'
    end

    it 'should be version 3.5.4.a1' do
      helper.should have_build_version(3, 5, 4, 'a1')
    end

    it "should bump major version" do
      helper.bump_major
      helper.should have_build_version(4, 0, 0, nil)
    end

    it "should bump the minor version" do
      helper.bump_minor
      helper.should have_build_version(3, 6, 0, nil)
    end

    it "should bump the patch version" do
      helper.bump_patch
      helper.should have_build_version(3, 5, 5, nil)
    end
  end
end
