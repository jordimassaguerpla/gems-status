require "rubygems"
require "xmlsimple"
require "open-uri"
require "zlib"

require "gem_simple"
require "gems_command"

class RubyGemsGems_GemSimple < GemSimple

  def md5
    puts "DEBUG: download and md5 for #{@name}"
    gem_spec_uri = "#{@origin}/api/v1/gems/rails.yaml"
    source = open(gem_spec_uri)
    gem_uri = ""
    YAML::load_documents(source) {|c| gem_uri = c["gem_uri"]}
    if !gem_uri
      return ""
    end
    source = open(gem_uri)
    digest = Digest::MD5.hexdigest(source.read)
    return digest
  end
end


class RubyGemsGems < GemsCommand

  def initialize(conf)
    check_parameters(conf)
    @url = conf['url']
    @specs = conf['specs']
    @result = {}

  end

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
    if !conf['specs'] then
      puts "ERROR: parameter specs not found for RubyGemsGems"
      exit
    end
  end

  def get_data
    specs_url = @url + "/" + @specs 
    source = open(specs_url)
    gz = Zlib::GzipReader.new(source)
    return gz.read
  end


  def execute
    response = get_data
    data = Marshal.load(response)
    data.each do |line|
      @result[line[0]] = RubyGemsGems_GemSimple.new(line[0], line[1],'' , @url)
    end
  end

end
