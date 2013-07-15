require "rubygems"
require "xmlsimple"
require "open-uri"
require "zlib"

require "bundler"
require "gems-status/gem_simple"
require "gems-status/utils"

module GemsStatus

  class LockfileGems
    attr_reader :filename
    def initialize(conf)
      Utils::check_parameters('LockfileGems', conf, ["id", "filename", "gems_url"])
      @filename = conf['filename']
      @gems_url = conf['gems_url']
      @result = {}
      @ident = conf['id']
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

    def execute
      Utils::log_debug "reading #{@filename}"
      Dir.chdir(File.dirname(@filename)) do
        file_data = get_data(File::dirname(@filename), File::basename(@filename))
        if file_data.empty?
          Utils::log_error("?", "file empty #{@filename}")
          return
        end
        lockfile = Bundler::LockfileParser.new(file_data)
        lockfile.specs.each do |spec|
          version = Gem::Version.create(spec.version)
          Utils::log_debug "dependencies for #{spec.name} #{spec.dependencies}"
          @result[spec.name] = GemSimple.new(spec.name, version , nil, 
                                             @filename, gems_url(spec), 
                                             spec.dependencies)
        end
      end
    end

    private

    def gems_url(spec)
      if spec.source.class.name == "Bundler::Source::Git"
        Utils::log_debug "this comes from git #{spec.name} #{spec.version}"
        spec.source.uri
      else
        @gems_url
      end
    end
  end
end
