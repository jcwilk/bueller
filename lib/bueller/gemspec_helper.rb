class Bueller
  class GemSpecHelper
    attr_accessor :spec, :base_dir

    def initialize(spec, base_dir = nil)
      self.spec = spec
      self.base_dir = base_dir || ''

      yield spec if block_given?
    end

    def valid?
      begin
        parse
        true
      rescue
        false
      end
    end

    def write
      File.open(path, 'w') do |f|
        f.write self.to_ruby
      end 
    end

    def to_ruby
      spec.to_ruby
    end

    def path
      denormalized_path = File.join(@base_dir, "#{@spec.name}.gemspec")
      absolute_path = File.expand_path(denormalized_path)
      absolute_path.gsub(Dir.getwd + File::SEPARATOR, '') 
    end

    def parse
      data = self.to_ruby
      parsed_gemspec = nil
      parsed_gemspec = eval("$SAFE = 3\n#{data}", binding, path)
      parsed_gemspec
    end

    def gem_path
      File.join(@base_dir, 'pkg', spec.file_name)
    end

    def update_version(version)
      @spec.version = version.to_s
    end
    
    # Checks whether it uses the version helper or the users defined version.
    def has_version?
      !@spec.version.nil?
    end
  end
end
