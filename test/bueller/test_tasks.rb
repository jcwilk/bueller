require 'test_helper'

require 'rake'
class TestTasks < Test::Unit::TestCase
  include Rake

  context 'instantiating Bueller::Tasks' do
    setup do
      @gemspec_building_block = lambda {}
      @tasks = Bueller::Tasks.new &@gemspec_building_block
    end

    teardown do
      Task.clear
    end

    should 'assign @gemspec' do
      assert_not_nil @tasks.gemspec
    end

    should 'not eagerly initialize Bueller' do
      assert ! @tasks.instance_variable_defined?(:@bueller)
    end

    should 'set self as the application-wide bueller tasks' do
      assert_same @tasks, Rake.application.bueller_tasks
    end

    should 'save gemspec building block for later' do
      assert_same @gemspec_building_block, @tasks.gemspec_building_block
    end

    context 'Bueller instance' do
      setup do
        @tasks.bueller
      end

      should 'initailize Bueller' do
        assert @tasks.instance_variable_defined?(:@bueller)
      end
    end

    should 'yield the gemspec instance' do
      spec = nil
      @tasks = Bueller::Tasks.new { |s| spec = s }
      assert_not_nil @tasks.bueller.gemspec
    end

  end
end
