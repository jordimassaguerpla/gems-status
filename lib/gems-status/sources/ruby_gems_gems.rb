require "rubygems"
require "xmlsimple"
require "open-uri"
require "zlib"

require "gems-status/sources/ruby_gems_gems_gem_simple"
require "gems-status/gems_command"
require "gems-status/utils"

module GemsStatus

  class RubyGemsGems < GemsCommand

    def initialize(conf)
      Utils::check_parameters('RubyGemsGems', conf, ["id", "url", "specs"])
      @url = conf['url']
      @specs = conf['specs']
      @result = {}
      @ident = conf['id']

    end

    def get_data
      specs_url = @url + "/" + @specs 
      begin
        source = open(specs_url)
        gz = Zlib::GzipReader.new(source)
        return gz.read
      rescue
        Utils::log_error "?", "There was a problem opening #{specs_url} "
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
        version = Gem::Version.new(line[1])
        gems_url = "#{@url}/gems"
        @result[name] = [RubyGemsGems_GemSimple.new(name, version,'' , @url, gems_url)]
      end
    end

  end
end
