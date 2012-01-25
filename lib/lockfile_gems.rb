require "rubygems"
require "xmlsimple"
require "open-uri"
require "zlib"

require "bundler"
require "ruby_gems_gems_gem_simple"
require "gems_command"

class LockfileGems < GemsCommand
  def initialize(conf)
    check_parameters(conf)
    @dirname = conf['dirname']
    @filename = conf['filename']
    @gems_url = conf['gems_url']
    @result = {}
  end

  def check_parameters(conf)
    if !conf['classname'] then
      $stderr.puts "ERROR: trying to initialize LockfileGems  when parameter classname does not exists"
      exit
    end
    if conf['classname']!="LockfileGems" then
      $stderr.puts "ERROR: trying to initialize LockfileGems when parameter classname is #{conf['classname']}"
      exit
    end
    if !conf['dirname'] then
      $stderr.puts "ERROR: parameter dirname not found for RubyGemsGems"
      exit
    end
    if !conf['filename'] then
      $stderr.puts "ERROR: parameter filename not found for RubyGemsGems"
      exit
    end
    if !conf['gems_url'] then
      $stderr.puts "ERROR: parameter gems_url not found for RubyGemsGems"
      exit
    end
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
