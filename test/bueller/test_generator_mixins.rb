require 'test_helper'

class TestGeneratorMixins < Test::Unit::TestCase

  [Bueller::Generator::BaconMixin,
   Bueller::Generator::MicronautMixin,
   Bueller::Generator::MinitestMixin,
   Bueller::Generator::RspecMixin,
   Bueller::Generator::ShouldaMixin,
   Bueller::Generator::TestspecMixin,
   Bueller::Generator::TestunitMixin,
  ].each do |mixin|
    context "#{mixin}" do
      %w(default_task feature_support_require feature_support_extend
         test_dir test_task test_pattern test_filename
         test_helper_filename).each do |method|
          should "define #{method}" do
            assert mixin.method_defined?(method)
          end
       end
    end
  end
end
