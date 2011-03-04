class Bueller
  class GemSpecHelper
    class VersionMissing < StandardError; end
    class NoGemspecFound < StandardError; end

    attr_accessor :spec, :spec_source, :base_dir, :errors

    def errors
      @errors ||= []
    end

    def initialize(base_dir = nil)
      self.base_dir = base_dir || ''
    end

    def valid?
      begin
        spec.validate
      rescue => e
        errors << "gemspec is invalid: #{e}"
        return false
      end

      true
    end

    def write
      File.open(path, 'w') do |f|
        f.puts spec_source
      end 
    end

    def path
      return @path unless @path.nil?
      denormalized_path = Dir.glob(File.join(base_dir, '*.gemspec')).first
      raise NoGemspecFound, "No gemspec found in #{base_dir}" if denormalized_path.nil?
      absolute_path = File.expand_path(denormalized_path)
      @path = absolute_path.gsub(Dir.getwd + File::SEPARATOR, '') 
    end

    def spec_source
      @spec_source ||= File.read(path)
    end

    def reload_spec
      @spec = nil
    end

    def spec
      @spec ||= Gem::Specification.load path
    end

    def gem_path
      File.join(base_dir, 'pkg', spec.file_name)
    end

    def set_date
      spec_source.sub! /\.date\s*=\s*.*/, %Q{.date = "#{Time.now.strftime('%Y-%m-%d')}"}
      reload_spec
    end

    def has_version?
      !spec.version.nil?
    end

    def version
      spec.version
    end

    def project_name
      spec.name
    end
  end
end
