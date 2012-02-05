require 'rubygems/format'
require 'rubygems/old_format'
require 'open-uri'
require 'gem_checker'

class NotRailsChecker < GemChecker
  def NotRailsChecker.check?(gem)
    result = nil
    gem_uri = "#{gem.gems_url}/#{gem.name}-#{gem.version}.gem" 
    begin
      source = open(gem_uri, Gem.binary_mode) do |io|
        result = Gem::Format.from_io io
      end
    rescue IOError
      #bug on open-uri:137 on closing strings
      #it should be
      #io.close if io && !io.closed? 
      #or is a bug on rubygems???
    rescue => e
      Utils.log_error "ERROR: There was a problem opening #{gem_uri} #{e.class} #{e.message}" 
    end
    return false unless result 
    result.spec.dependencies.each do |gem|
      return false if gem.name == "rails"
    end
    return true
  end

  def NotRailsChecker.description
    "This gem depends on rails or could not get spec: "
  end
end

