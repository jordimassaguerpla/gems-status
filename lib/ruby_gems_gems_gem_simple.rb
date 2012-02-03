require "gem_simple"

class RubyGemsGems_GemSimple < GemSimple

  def initialize(name, version, md5, origin, gems_url)
    super(name, version, nil, origin, gems_url)
  end

  def md5
    if @md5
      return @md5
    end
    gem_uri = "#{@gems_url}/#{@name}-#{@version}.gem" 
    $stderr.puts "DEBUG: download and md5 for #{@name} from #{gem_uri}"
    begin
      source = open(gem_uri)
      @md5 = Digest::MD5.hexdigest(source.read)
      return @md5
    rescue
      $stderr.puts "ERROR: There was a problem opening #{gem_uri}" 
    end 
    return nil
  end
end

