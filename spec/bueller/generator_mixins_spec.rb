require 'spec_helper'

# FIXME: use example groups/it_should_behave_like instead
describe 'Bueller::Generator Mixins' do
  [Bueller::Generator::BaconMixin,
   Bueller::Generator::MicronautMixin,
   Bueller::Generator::MinitestMixin,
   Bueller::Generator::RspecMixin,
   Bueller::Generator::ShouldaMixin,
   Bueller::Generator::TestspecMixin,
   Bueller::Generator::TestunitMixin,
  ].each do |mixin|
    describe "#{mixin}" do
      %w(default_task feature_support_require feature_support_extend
         test_dir test_task test_pattern test_filename
         test_helper_filename).each do |method|
          it "should define #{method}" do
            mixin.method_defined?(method).should be_true
          end
       end
    end
  end
end
