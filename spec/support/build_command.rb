module BuildCommand
  def self.context(description, &block)
    context description do
      setup do

        @repo           = Object.new
        @version_helper = Object.new
        @gemspec        = Object.new
        @commit         = Object.new
        @version        = Object.new
        @output         = Object.new
        @base_dir       = Object.new
        @gemspec_helper = Object.new
        @rubyforge      = Object.new

        @jeweler        = Object.new

        stub(@jeweler).repo           { @repo }
        stub(@jeweler).version_helper { @version_helper }
        stub(@jeweler).gemspec        { @gemspec }
        stub(@jeweler).commit         { @commit }
        stub(@jeweler).version        { @version }
        stub(@jeweler).output         { @output }
        stub(@jeweler).gemspec_helper { @gemspec_helper }
        stub(@jeweler).base_dir       { @base_dir }
        stub(@jeweler).rubyforge    { @rubyforge }
      end

      context "", &block
    end

  end
end
