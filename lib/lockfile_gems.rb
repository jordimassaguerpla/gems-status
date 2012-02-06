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
    Utils::check_parameters('LockfileGems', conf, ["id", "filenames", "gems_url"])
    @filenames = conf['filenames']
    @gems_url = conf['gems_url']
    @result = {}
    @ident = conf['id']
  end

  def get_data(dirname, filename)
    Dir.chdir(dirname)
    data = ""
    begin
      data = File.open(filename).read
    rescue
      Utils::log_error "ERROR: There was a problem opening file #{filename} "
    end
    return data
  end

  def execute
    @filenames.each do |filename|
      Utils::log_debug "DEBUG: reading #{filename}"
      file_data = get_data(File::dirname(filename), File::basename(filename))
      if file_data.empty?
        Utils::log_error "ERROR: file empty #{filename}"
        next
      end
      lockfile = Bundler::LockfileParser.new(file_data)
      lockfile.specs.each do |spec|
        name = spec.name
        version = Gem::Version.create(spec.version)
        if @result[name] && @result[name].version != version
          Utils::log_error "ERROR: Same gem with different versions: #{name} - #{version} - #{filename}\n       #{name} - #{@result[name].version} - #{@result[name].origin} "
        end
        @result[name] = RubyGemsGems_GemSimple.new(name, version , '', filename, @gems_url)
      end
    end
  end

end
