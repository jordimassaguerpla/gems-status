require 'rubygems/format'
require 'rubygems/old_format'
require 'open-uri'
require 'gems-status/gem_checker'

class NotNativeGemChecker < GemChecker
  def check?(gem)
    result = nil
    gem_uri = URI.parse("#{gem.gems_url}/#{gem.name}-#{gem.version}.gem" )
    uri_debug = gem_uri.clone
    uri_debug.password = "********" if uri_debug.password
    Utils::log_debug "download #{@name} from #{uri_debug}"
    begin
      if gem_uri.user && gem_uri.password
        source = open(gem_uri.scheme + "://" + gem_uri.host + "/" + gem_uri.path, 
                      Gem.binary_mode,
                      :http_basic_authentication=>[gem_uri.user, gem_uri.password]) do |io|
          result = Gem::Format.from_io io
        end
      else
        source = open(gem_uri, Gem.binary_mode) do |io|
          result = Gem::Format.from_io io
        end
      end
    rescue IOError
      #bug on open-uri:137 on closing strings
      #it should be
      #io.close if io && !io.closed? 
      #or is a bug on rubygems???
    rescue => e
      Utils::log_error(gem.name, "There was a problem opening #{gem_uri} #{e.class} #{e.message}")
    end
    return false unless result 
    return result.spec.extensions.empty?
  end

  def description
    "This gem is a native gem or could not get specs: "
  end
end

