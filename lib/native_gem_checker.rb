require 'rubygems/format'
require 'rubygems/old_format'
require 'open-uri'

class NotNativeGemChecker
  def NotNativeGemChecker.check?(gem)
    name = gem.name
    version = gem.version
    gems_url = gem.gems_url
    result = nil
    gem_uri = "#{gems_url}/#{name}-#{version}.gem" 
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
      $stderr.puts "ERROR: There was a problem opening #{gem_uri} #{e.class} #{e.message}" 
    end
    return false unless result 
    return !result.spec.extensions.empty?
  end
end

