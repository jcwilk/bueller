require 'ruby_parser'
require 'ruby2ruby'

class Bueller
  class GemSpecHelper
    class VersionMissing < StandardError; end

    attr_accessor :spec, :spec_ruby, :spec_sexp, :base_dir, :errors

    def errors
      @errors ||= []
    end

    def initialize(base_dir = nil)
      self.base_dir = base_dir || ''
    end

    def valid?
      begin
        reload_spec
      rescue => e
        errors << "could not eval gemspec: #{e}"
        return false
      end

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
        f.puts spec_sexp
      end 
    end

    def path
      denormalized_path = Dir.glob(File.join(base_dir, '*.gemspec')).first
      absolute_path = File.expand_path(denormalized_path)
      absolute_path.gsub(Dir.getwd + File::SEPARATOR, '') 
    end

    def spec
      @spec ||= reload_spec
    end

    def spec_ruby
      @spec_ruby ||= File.read(path)
    end

    def spec_sexp
      @spec_sexp ||= RubyParser.new.parse(spec_ruby)
    end

    def reload_spec
      @spec = eval(Ruby2Ruby.new.process(spec_sexp))
    end

    def gem_path
      File.join(base_dir, 'pkg', spec.file_name)
    end

    def update_version(version)
      raise VersionMissing unless has_version?
      version_node = sexp_version
      version_node.last.last = version
      reload_spec
    end

    def sexp_version(exp = spec_sexp)
      return nil unless exp.is_a? RubyParser::Sexp
      puts "examining #{exp.first.inspect} => #{exp[1..-1]}"
      return exp if exp.first == :attrasgn and exp.include?(:version=)
      result = exp.each do |subexp|
        tangent = sexp_version(subexp)
        return tangent unless tangent.nil?
      end
      nil
    end
    
    def has_version?
      !spec.version.nil?
    end

    def version
      spec.version
    end
  end
end
