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
    Utils::check_parameters('LockfileGems', conf, ["dirname", "filename", "gems_url"])
    @dirname = conf['dirname']
    @filename = conf['filename']
    @gems_url = conf['gems_url']
    @result = {}
  end

  def get_data
    Dir.chdir(@dirname)
    data = ""
    begin
      data = File.open(@filename).read
    rescue
      $stderr.puts "ERROR: There was a problem opening file #{filename} "
    end
    return data
  end

  def execute
    $stderr.puts "DEBUG: reading #{@filename}"
    file_data = get_data
    if file_data.empty?
      return
    end
    lockfile = Bundler::LockfileParser.new(file_data)
    lockfile.specs.each do |spec|
      name = spec.name
      version = spec.version
      @result[name] = RubyGemsGems_GemSimple.new(name, Gem::Version.create(version) , '', @filename, @gems_url)
    end
  end

end
