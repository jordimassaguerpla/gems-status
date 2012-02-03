require 'rubygems'
require 'open-uri'
require 'gem_checker'

class ExistsInUpstream < GemChecker
  def ExistsInUpstream.check?(gem)
    $stderr.puts "DEBUG: Looking for #{gem.name}"
    result = nil
    gem_uri = "#{gem.gems_url}/#{gem.name}-#{gem.version}.gem" 
    begin
      source = open(gem_uri)
      return true
    rescue
      return false
    end
  end
  def ExistsInUpstream.description
    "This gem does not exist in upstream: "
  end
end

