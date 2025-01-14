require 'git'
require 'erb'

require 'net/http'
require 'uri'

require 'fileutils'

class Bueller
  class NoGitUserName < StandardError
  end
  class NoGitUserEmail < StandardError
  end
  class FileInTheWay < StandardError
  end
  class NoGitHubRepoNameGiven < StandardError
  end
  class NoGitHubUser < StandardError
  end
  class NoGitHubToken < StandardError
  end
  class GitInitFailed < StandardError
  end    

  # Generator for creating a bueller-enabled project
  class Generator    
    require 'bueller/generator/options'
    require 'bueller/generator/application'

    require 'bueller/generator/github_mixin'

    require 'bueller/generator/bacon_mixin'
    require 'bueller/generator/micronaut_mixin'
    require 'bueller/generator/minitest_mixin'
    require 'bueller/generator/rspec_mixin'
    require 'bueller/generator/shoulda_mixin'
    require 'bueller/generator/testspec_mixin'
    require 'bueller/generator/testunit_mixin'
    require 'bueller/generator/riot_mixin'
    require 'bueller/generator/shindo_mixin'

    require 'bueller/generator/rdoc_mixin'
    require 'bueller/generator/yard_mixin'

    attr_accessor :target_dir, :user_name, :user_email, :summary, :homepage,
                  :description, :project_name, :github_username, :github_token,
                  :repo, :create_remote_repo, 
                  :testing_framework, :documentation_framework,
                  :use_cucumber, :setup_gemcutter,
                  :setup_rubyforge, :use_reek, :use_roodi,
                  :development_dependencies,
                  :options,
                  :git_remote

    alias :create_remote_repo? :create_remote_repo
    alias :use_cucumber? :use_cucumber
    alias :setup_rubyforge? :setup_rubyforge
    alias :use_reek? :use_reek
    alias :use_roodi? :use_roodi

    def self.run(options = {})
      generator = self.new(options)
      generator.run
    end

    def initialize(options = {})
      self.options = options

      self.project_name   = options[:project_name]
      if self.project_name.nil? || self.project_name.squeeze.strip == ""
        raise NoGitHubRepoNameGiven
      end

      self.development_dependencies = []
      self.testing_framework  = options[:testing_framework]
      self.documentation_framework = options[:documentation_framework]
      begin
        generator_mixin_name = "#{testing_framework.to_s.capitalize}Mixin"
        generator_mixin = self.class.const_get(generator_mixin_name)
        extend generator_mixin
      rescue NameError => e
        raise ArgumentError, "Unsupported testing framework (#{testing_framework})"
      end

      begin
        generator_mixin_name = "#{self.documentation_framework.to_s.capitalize}Mixin"
        generator_mixin = self.class.const_get(generator_mixin_name)
        extend generator_mixin
      rescue NameError => e
        raise ArgumentError, "Unsupported documentation framework (#{documentation_framework})"
      end

      self.target_dir             = options[:directory] || self.project_name

      self.summary                = options[:summary] || 'TODO: one-line summary of your gem'
      self.description            = options[:description] || 'TODO: detailed description of your gem'
      self.use_cucumber    = options[:use_cucumber]
      self.use_reek        = options[:use_reek]
      self.use_roodi       = options[:use_roodi]
      self.setup_gemcutter = options[:gemcutter]
      self.setup_rubyforge = options[:rubyforge]

      development_dependencies << 'cucumber' if use_cucumber?

      development_dependencies << 'bundler'
      development_dependencies << 'bueller'
      development_dependencies << 'rake'
      development_dependencies << 'rcov'

      development_dependencies << 'reek' if use_reek?
      development_dependencies << 'roodi' if use_roodi?

      self.user_name       = options[:user_name]
      self.user_email      = options[:user_email]
      self.homepage        = options[:homepage]
      
      self.git_remote      = options[:git_remote]

      raise NoGitUserName unless self.user_name
      raise NoGitUserEmail unless self.user_email

      extend GithubMixin
    end

    def run
      create_files
      create_version_control
      $stdout.puts "Bueller has prepared your gem in #{target_dir}"
      if create_remote_repo?
        create_and_push_repo
        $stdout.puts "Bueller has pushed your repo to #{homepage}"
      end
    end

    def constant_name
      self.project_name.split(/[-_]/).collect{|each| each.capitalize }.join
    end

    def lib_filename
      "#{project_name}.rb"
    end

    def require_name
      self.project_name
    end

    def file_name_prefix
      self.project_name.gsub('-', '_')
    end

    def lib_dir
      'lib'
    end

    def feature_filename
      "#{project_name}.feature"
    end

    def steps_filename
      "#{project_name}_steps.rb"
    end

    def features_dir
      'features'
    end

    def features_support_dir
      File.join(features_dir, 'support')
    end

    def features_steps_dir
      File.join(features_dir, 'step_definitions')
    end

  private

    def create_files
      unless File.exists?(target_dir) || File.directory?(target_dir)
        FileUtils.mkdir target_dir
      else
        raise FileInTheWay, "The directory #{target_dir} already exists, aborting. Maybe move it out of the way before continuing?"
      end

      require 'bundler'
      require 'bundler/cli'

      Dir.chdir File.dirname(target_dir) do
        cli = Bundler::CLI.new
        cli.gem project_name
      end

      append_template_in_target '.gitignore'
      output_template_in_target 'Rakefile'
      output_template_in_target 'LICENSE'
      output_template_in_target 'README.rdoc'
      output_template_in_target '.document'
      output_template_in_target 'gemspec', "#{project_name}.gemspec"

      mkdir_in_target           test_dir
      output_template_in_target File.join(testing_framework.to_s, 'helper.rb'),
                                File.join(test_dir, test_helper_filename)
      output_template_in_target File.join(testing_framework.to_s, 'flunking.rb'),
                                File.join(test_dir, test_filename)

      if use_cucumber?
        mkdir_in_target           features_dir
        output_template_in_target File.join(%w(features default.feature)), File.join('features', feature_filename)

        mkdir_in_target           features_support_dir
        output_template_in_target File.join(features_support_dir, 'env.rb')

        mkdir_in_target           features_steps_dir
        touch_in_target           File.join(features_steps_dir, steps_filename)
      end
    end

    def render_template(source)
      template_contents = File.read(File.join(template_dir, source))
      template          = ERB.new(template_contents, nil, '<>')

      # squish extraneous whitespace from some of the conditionals
      template.result(binding).gsub(/\n\n\n+/, "\n\n")
    end

    def append_template_in_target(source, destination = source)
      final_destination = File.join(target_dir, destination)
      template_result   = render_template(source)

      File.open(final_destination, 'a') {|file| file.write(template_result)}

      $stdout.puts "\tappend\t#{destination}"
    end

    def output_template_in_target(source, destination = source)
      final_destination = File.join(target_dir, destination)
      template_result   = render_template(source)

      File.open(final_destination, 'w') {|file| file.write(template_result)}

      $stdout.puts "\tcreate\t#{destination}"
    end

    def template_dir
      File.join(File.dirname(__FILE__), 'templates')
    end

    def mkdir_in_target(directory)
      final_destination = File.join(target_dir, directory)

      FileUtils.mkdir final_destination

      $stdout.puts "\tcreate\t#{directory}"
    end

    def touch_in_target(destination)
      final_destination = File.join(target_dir, destination)
      FileUtils.touch  final_destination
      $stdout.puts "\tcreate\t#{destination}"
    end

    def create_version_control
      Dir.chdir(target_dir) do
        begin
          @repo = Git.init()
        rescue Git::GitExecuteError => e
          raise GitInitFailed, "Encountered an error during gitification. Maybe the repo already exists, or has already been pushed to?"
        end

        begin
          @repo.add('.')
        rescue Git::GitExecuteError => e
          #raise GitAddFailed, "There was some problem adding this directory to the git changeset"
          raise
        end

        begin
          @repo.commit "Initial commit to #{project_name}."
        rescue Git::GitExecuteError => e
          raise
        end

        begin
          @repo.add_remote('origin', git_remote)
        rescue Git::GitExecuteError => e
          puts "Encountered an error while adding origin remote. Maybe you have some weird settings in ~/.gitconfig?"
          raise
        end
      end
    end
    
    def create_and_push_repo
      Net::HTTP.post_form URI.parse('http://github.com/api/v2/yaml/repos/create'),
                                'login' => github_username,
                                'token' => github_token,
                                'description' => summary,
                                'name' => project_name
      # TODO do a HEAD request to see when it's ready?
      @repo.push('origin')
    end
  end
end
