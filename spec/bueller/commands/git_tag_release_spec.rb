require 'spec_helper'

describe Bueller::Commands::GitTagRelease do
  let(:bueller) { Bueller.new }
  let(:command) { Bueller::Commands::GitTagRelease.new bueller, :output => StringIO.new }

  before :each do
    status = mock(Object)
    bueller.repo = mock(Git, :status => status)

    command.repo.status.stub!(:added).and_return []
    command.repo.status.stub!(:changed).and_return []
    command.repo.status.stub!(:deleted).and_return []
  end

  describe '#run' do
    before :each do
      command.repo.stub! :checkout
      command.repo.stub! :push
      command.repo.stub! :add_tag
      command.stub!(:clean_staging_area?).and_return true
      command.stub!(:release_tagged?).and_return true
    end

    it 'should not run if the staging area is unclean and user does not confirm' do
      command.stub!(:clean_staging_area?).and_return false
      $stdin.stub!(:gets).and_return 'no'
      expect { command.run }.should raise_error
    end
    it 'should run if the staging area is unclean and user confirms' do
      command.stub!(:clean_staging_area?).and_return false
      $stdin.stub!(:gets).and_return 'yes'
      command.repo.should_receive :checkout
      command.run
    end
    it 'should check out master' do
      command.repo.should_receive(:checkout).with 'master'
      command.run
    end
    it 'should push' do
      command.repo.should_receive :push
      command.run
    end
    it 'should not push tags if the release is already tagged' do
      command.repo.should_not_receive :add_tag
      command.repo.should_receive :push

      command.run
    end
    it 'should push tags if the release is not tagged' do
      command.stub!(:release_tagged?).and_return false
      command.repo.should_receive :add_tag
      command.repo.should_receive :push

      command.run
    end
  end

  describe "#release_tagged?" do
    it 'should be true if a tag exists' do
      command.repo.stub!(:tag).and_raise RuntimeError
      command.release_tagged?.should be_false
    end
    it 'should be false if no tag exists' do
      command.repo.stub!(:tag)
      command.release_tagged?.should be_true
    end
  end

  describe '#clean_staging_area?' do
    it 'should return true if there are no added, changed, or deleted files' do
      command.should be_clean_staging_area
    end
    it 'should return false if there are added files' do
      command.repo.status.stub!(:added).and_return ['Gemfile.lock']
      command.should_not be_clean_staging_area
    end
    it 'should return false if there are changed files' do
      command.repo.status.stub!(:changed).and_return ['Gemfile.lock']
      command.should_not be_clean_staging_area
    end
    it 'should return false if there are deleted files' do
      command.repo.status.stub!(:deleted).and_return ['Gemfile.lock']
      command.should_not be_clean_staging_area
    end
  end
end
