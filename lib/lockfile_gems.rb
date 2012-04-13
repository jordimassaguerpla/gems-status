require "rubygems"
require "xmlsimple"
require "open-uri"
require "zlib"

require "bundler"
require "ruby_gems_gems_gem_simple"
require "gems_command"
require "utils"

class LockfileGems < GemsCommand
  def initialize(conf)
    Utils::check_parameters('LockfileGems', conf, ["id", "filenames", "gems_url", "upstream_url"])
    @filenames = conf['filenames']
    @gems_url = conf['gems_url']
    @result = {}
    @ident = conf['id']
    @upstream_url = conf['upstream_url']
  end

  def get_data(dirname, filename)
    data = ""
    Dir.chdir(dirname) do
      begin
        data = File.open(filename).read
      rescue
        Utils::log_error("?", "There was a problem opening file #{filename} ")
      end
    end
    return data
  end

  def update_gem_dependencies(gem)
    Utils::log_debug("updating dependencies for #{gem.name}")
    changes = false
    @result.each do |k, gems|
      gems.each do |gem2|
        if gem.depends?(gem2)
          changes = gem.merge_deps(gem2) || changes
        end
      end
    end
    return changes
  end

  def update_dependencies
    changes = false
    @result.each do |k, gems|
      gems.each do |gem|
        changes = update_gem_dependencies(gem) || changes
      end
    end
    update_dependencies if changes
  end

  def execute
    @filenames.each do |filename|
      Utils::log_debug "reading #{filename}"
      file_data = get_data(File::dirname(filename), File::basename(filename))
      if file_data.empty?
        Utils::log_error("?", "file empty #{filename}")
        next
      end
      lockfile = Bundler::LockfileParser.new(file_data)
      lockfile.specs.each do |spec|
        name = spec.name
        version = Gem::Version.create(spec.version)
        dependencies = spec.dependencies
        Utils::log_debug "dependencies for #{name} #{dependencies}"
        if spec.source.class.name == "Bundler::Source::Git"
          Utils::log_debug "this comes from git #{name} #{version}"
          gems_url = spec.source.uri
        else 
          gems_url = @gems_url
        end
        @result[name] = [] if !@result[name]
        @result[name] << RubyGemsGems_GemSimple.new(name, version , '', filename,
                                                   gems_url, dependencies)
        @result[name] << RubyGemsGems_GemSimple.new(name, version , '', @upstream_url,
                                                   @upstream_url, dependencies)
      end
      update_dependencies
    end
  end

end
