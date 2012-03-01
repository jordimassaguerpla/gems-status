require "gem_simple"

class RubyGemsGems_GemSimple < GemSimple

  def initialize(name, version, md5, origin, gems_url, dependencies=nil)
    super(name, version, nil, origin, gems_url, dependencies)
  end

  def md5
    if @md5
      return @md5
    end
    if from_git?
      return nil
    end
    gem_uri = URI.parse("#{@gems_url}/#{@name}-#{@version}.gem")
    uri_debug = gem_uri.clone
    uri_debug.password = "********" if uri_debug.password
    Utils::log_debug "download and md5 for #{@name} from #{uri_debug}"
    begin
      if gem_uri.user && gem_uri.password
        source = open(gem_uri.scheme + "://" + gem_uri.host + "/" + gem_uri.path, 
                      :http_basic_authentication=>[gem_uri.user, gem_uri.password])
      else
        source = open(gem_uri)
      end
      @md5 = Digest::MD5.hexdigest(source.read)
      return @md5
    rescue
      Utils::log_error(@name, "There was a problem opening #{gem_uri}")
    end 
    return nil
  end

  def from_git?
    return @gems_url.start_with?("git://")
  end
end

