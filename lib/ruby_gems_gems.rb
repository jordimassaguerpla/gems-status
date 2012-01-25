require "rubygems"
require "xmlsimple"
require "open-uri"
require "zlib"

require "ruby_gems_gems_gem_simple"
require "gems_command"


class RubyGemsGems < GemsCommand

  def initialize(conf)
    check_parameters(conf)
    @url = conf['url']
    @specs = conf['specs']
    @result = {}

  end

  def check_parameters(conf)
    if !conf['classname'] then
      $stderr.puts "ERROR: trying to initialize RubyGemsGems when parameter classname does not exists"
      exit
    end
    if conf['classname']!="RubyGemsGems" then
      $stderr.puts "ERROR: trying to initialize RubyGemsGems when parameter classname is #{conf['classname']}"
      exit
    end
    if !conf['url'] then
      $stderr.puts "ERROR: parameter url not found for RubyGemsGems"
      exit
    end
    if !conf['specs'] then
      $stderr.puts "ERROR: parameter specs not found for RubyGemsGems"
      exit
    end
  end

  def get_data
    specs_url = @url + "/" + @specs 
    begin
      source = open(specs_url)
      gz = Zlib::GzipReader.new(source)
      return gz.read
    rescue
      $stderr.puts "ERROR: There was a problem opening #{specs_url} "
    end
    return ""
  end


  def execute
    response = get_data
    if response.empty? then
      return
    end
    data = Marshal.load(response)
    data.each do |line|
      name = line[0]
      version = line[1]
      gems_url = "#{@url}/gems"
      @result[name] = RubyGemsGems_GemSimple.new(name, version,'' , @url, gems_url)
    end
  end

end
