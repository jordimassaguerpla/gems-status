require "rubygems"
require "xmlsimple"
require "open-uri"
require "zlib"

require "gemsimple"
require "gemscommand"

class RubyGemsGems < GemsCommand
  def check_parameters(conf)
    if !conf['classname'] then
      puts "ERROR: trying to initialize RubyGemsGems when parameter classname does not exists"
      exit
    end
    if conf['classname']!="RubyGemsGems" then
      puts "ERROR: trying to initialize RubyGemsGems when parameter classname is #{conf['classname']}"
      exit
    end
    if !conf['url'] then
      puts "ERROR: parameter url not found for RubyGemsGems"
      exit
    end
  end

  def initialize(conf)
    check_parameters(conf)
    @url = conf['url']
    @result = {}

  end

  def execute
    source = open(@url)
    gz = Zlib::GzipReader.new(source)
    response = gz.read
    data = Marshal.load(response)
    data.each do |line|
      #TODO: fetch gem and md5
      #curl /api/v1/gems/[GEM NAME].(json|xml|yaml) <- version and download url
      @result[line[0]] = GemSimple.new(line[0], line[1], 'md5', @url)
    end
  end

end
