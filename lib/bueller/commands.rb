class Bueller
  module Commands
    autoload :WriteGemspec, 'bueller/commands/write_gemspec'

    module Version
      autoload :Base,      'bueller/commands/version/base'
      autoload :BumpMajor, 'bueller/commands/version/bump_major'
      autoload :BumpMinor, 'bueller/commands/version/bump_minor'
      autoload :BumpPatch, 'bueller/commands/version/bump_patch'
      autoload :Write,     'bueller/commands/version/write'
    end
  end
end
