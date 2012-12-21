require "gems-status/gem_simple"
require "time"

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
    @md5 = nil
    begin
      @md5 = Utils::download_md5(gem_uri)
    rescue
      Utils::log_error(@name, "There was a problem opening #{gem_uri}")
    end 
    return @md5
  end

  def date
    Utils::log_debug "looking for date for #{@name} - #{@version}"
    begin
      versions = JSON.parse(open("https://rubygems.org/api/v1/versions/#{@name}.json").read)
      versions.each do |version|
        if Gem::Version.new(version["number"]) == @version
          Utils::log_debug  "Date for #{@name} - #{@version} : #{version["built_at"]}"
          return Time.parse version["built_at"]
        end
      end
    rescue
      Utils::log_error(@name, "There was a problem opening https://rubygems.org/api/v1/versions/#{@name}.json")
    end
    nil
  end

end

