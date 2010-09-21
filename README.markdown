# Bueller: Craft the absolute perfect RubyGem

Bueller provides two things:

 * Rake tasks for managing gems and versioning of a <a href="http://github.com">GitHub</a> project
 * A generator for creating/kickstarting a new project

## Quick Links

 * [Wiki](http://wiki.github.com/dkastner/bueller)
 * [Bugs](http://github.com/dkastner/bueller/issues)

## Installing

# Install the gem:
    gem install bueller

## Using in an existing project

Since bueller uses your existing gemspec, simply add the bueller tasks to your Rakefile:

    begin
      require 'bueller'
      Bueller::Tasks.new
    rescue LoadError
      puts "Bueller not available. Install it with: gem install bueller"
    end

## Using to start a new project

Bueller provides a generator. It requires you to [setup your name and email for git](http://help.github.com/git-email-settings/) and [your username and token for GitHub](http://github.com/guides/local-github-config).

    bueller the-perfect-gem

This will prepare a project in the 'the-perfect-gem' directory, setup to use Bueller.

It supports a number of options. Here's a taste, but `bueller --help` will give you the most up-to-date listing:

 * --create-repo: in addition to preparing a project, it create an repo up on GitHub and enable RubyGem generation
 * --testunit: generate test_helper.rb and test ready for test/unit
 * --minitest: generate test_helper.rb and test ready for minitest
 * --shoulda: generate test_helper.rb and test ready for shoulda
 * --rspec: generate spec_helper.rb and spec ready for rspec (this is the default)
 * --bacon: generate spec_helper.rb and spec ready for bacon
 * --gemcutter: setup releasing to gemcutter
 * --rubyforge: setup releasing to rubyforge

### Default options

Bueller respects the BUELLER_OPTS environment variable. Want to always use Test::Unit, and you're using bash? Add this to ~/.bashrc:

    export BUELLER_OPTS="--testunit"

## Gemspec

Bueller leaves the task of defining a clean gemspec to you. However, it does offer a method to bump version numbers via rake tasks.

    rake version:bump:minor

When starting from scratch, bueller will create a skeleton gemspec for you.

## Gem

Bueller gives you tasks for building and installing your gem.

    rake install

To build the gem (which will end up in `pkg`), run:

    rake build

To install the gem (and build if necessary), i.e. using gem install, run:

    rake install

Note, this does not use `sudo` to install it, so if your ruby setup needs that, you should prefix it with sudo:

    sudo rake install

## Versioning

Bueller tracks the version of your project. It assumes you will be using a version in the format `x.y.z`. `x` is the 'major' version, `y` is the 'minor' version, and `z` is the patch version.

Initially, your project starts out at 0.0.0. Bueller provides Rake tasks for bumping the version:

    rake version:bump:major
    rake version:bump:minor
    rake version:bump:patch

You can also programmatically set the version if you wish. Typically, you use this to have a module with the version info so clients can access it. The only downside here is you no longer can use the version:bump tasks.

    Gem::Specification.new do |s|
       s.version = MyProject::VERSION
       # more stuff
    end

### Prerelease versioning

Major, minor, and patch versions have a distant cousin: build. You can use this to add an arbitrary (or you know, regular type) version. This is particularly useful for prereleases.

You have two ways of doing this:

 * Use `version:write` and specify `BUILD=pre1`

Bueller does not provide a `version:bump:build` because the build version can really be anything, so it's hard to know what should be the next bump.

## Releasing

Bueller handles releasing your gem into the wild:

    rake release

It does the following for you:

 * git pushes to origin/master branch
 * git tags the version and pushes to the origin remote

As is though, it doesn't actually get your gem anywhere. To do that, you'll need to use rubyforge or gemcutter.

### Releasing to Gemcutter

Bueller can also handle releasing to [Gemcutter](http://gemcutter.org). There are a few steps you need to do before doing any Gemcutter releases with Bueller:

 * [Create an account on Gemcutter](http://gemcutter.org/sign_up)
 * Install the Gemcutter gem: gem install gemcutter
 * Run 'gem tumble' to set up RubyGems to use gemcutter as the default source if you haven't already
 * Update your Rakefile to make an instance of `Bueller::GemcutterTasks`


A Rakefile setup for gemcutter would include something like this:

    begin
      require 'bueller'
      Bueller::Tasks.new
      Bueller::GemcutterTasks.new
    rescue LoadError
      puts "Bueller (or a dependency) not available. Install it with: gem install bueller"
    end


After you have configured this, `rake release` will now also release to Gemcutter.

If you need to release it without the rest of the release task, you can run:

    $ rake gemcutter:release

### Releasing to RubyForge

Bueller can also handle releasing to [RubyForge](http://rubyforge.org). There are a few steps you need to do before doing any RubyForge releases with Bueller:

 * [Create an account on RubyForge](http://rubyforge.org/account/register.php)
 * Request a project on RubyForge.
 * Install the RubyForge gem: gem install rubyforge
 * Run 'rubyforge setup' and fill in your username and password for RubyForge
 * Run 'rubyforge config' to pull down information about your projects
 * Run 'rubyforge login' to make sure you are able to login
 * In Bueller::Tasks, you must set `rubyforge_project` to the project you just created
 * Add Bueller::RubyforgeTasks to bring in the appropriate tasks.
 * Note, using `bueller --rubyforge` when generating the project does this for you automatically.

A gemspec setup for rubyforge would include something like this:

    Gem::Specification.new do |s|
      # ommitted for brevity
      gemspec.rubyforge_project = 'the-perfect-gem' # This line would be new
    end

Now you must initially create a 'package' for your gem in your RubyForge 'project':

    $ rake rubyforge:setup

After you have configured this, `rake release` will now also release to RubyForge.

If you need to release it without the rest of the release task, you can run:

    $ rake rubyforge:release

## Development and Release Workflow

 * Hack, commit, hack, commit, etc, etc
 * `rake version:bump:patch release` to do the actual version bump and release
 * Have a delicious beverage (I suggest port)
