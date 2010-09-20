module BuildCommand
  def self.context(env, description, &block)
    env.context description do
      before :each do
        @repo           = mock(Object)
        @commit         = mock(Object)
        @version        = mock(Object)
        @output         = mock(Object)
        @base_dir       = mock(Object)
        @gemspec_helper = mock(Object)
        @rubyforge      = mock(Object)

        @jeweler        = mock(Object)

        @jeweler.stub!(:repo          ).and_return(@repo)
        @jeweler.stub!(:version_helper).and_return(@version_helper)
        @jeweler.stub!(:gemspec       ).and_return(@gemspec)
        @jeweler.stub!(:commit        ).and_return(@commit)
        @jeweler.stub!(:version       ).and_return(@version)
        @jeweler.stub!(:output        ).and_return(@output)
        @jeweler.stub!(:gemspec_helper).and_return(@gemspec_helper)
        @jeweler.stub!(:base_dir      ).and_return(@base_dir)
        @jeweler.stub!(:rubyforge     ).and_return(@rubyforge)
      end

      instance_eval &block
    end
  end
end
