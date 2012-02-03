require 'rubygems'
require 'open-uri'

class ExistsInUpstream
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
end

