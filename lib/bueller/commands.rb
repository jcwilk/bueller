class Bueller
  module Commands
    autoload :BuildGem, 'bueller/commands/build_gem'
    autoload :InstallGem, 'bueller/commands/install_gem'
    autoload :GitTagRelease, 'bueller/commands/git_tag_release'
    autoload :ReleaseToGithub, 'bueller/commands/release_to_github'
    autoload :ReleaseToGemcutter, 'bueller/commands/release_to_gemcutter'
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
