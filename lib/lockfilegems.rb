require "rubygems"
require "xmlsimple"
require "open-uri"
require "zlib"

require "bundler"
require "gemsimple"
require "gemscommand"

class LockfileGems < GemsCommand
  def check_parameters(conf)
    if !conf['classname'] then
      puts "ERROR: trying to initialize LockfileGems  when parameter classname does not exists"
      exit
    end
    if conf['classname']!="LockfileGems" then
      puts "ERROR: trying to initialize LockfileGems when parameter classname is #{conf['classname']}"
      exit
    end
    if !conf['dirname'] then
      puts "ERROR: parameter dirname not found for RubyGemsGems"
      exit
    end
    if !conf['filename'] then
      puts "ERROR: parameter filename not found for RubyGemsGems"
      exit
    end
  end

  def initialize(conf)
    check_parameters(conf)
    @dirname = conf['dirname']
    @filename = conf['filename']
    @result = {}

  end

  def execute
    puts "reading #{@path}"
    Dir.chdir(@dirname)
    file_data = File.open(@filename).read
    lockfile = Bundler::LockfileParser.new(file_data)
    lockfile.specs.each do |spec|
      #TODO: fetch gem and md5?
      name = spec.name
      version = spec.version
      @result[name] = GemSimple.new(name, version , 'md5', @dirname + "/" + @filename)
    end
  end

end
