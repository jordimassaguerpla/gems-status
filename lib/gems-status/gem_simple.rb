module GemsStatus

  class GemSimple
    attr_reader :name, :version, :md5, :origin, :gems_url, :dependencies
    def initialize(name, version, md5, origin, gems_url=nil, dependencies = nil )
      @name = name
      @version = version
      @md5 = md5
      @origin = origin
      @gems_url = gems_url
      @dependencies = dependencies
    end

    def from_git?
      return @gems_url && @gems_url.start_with?("git://")
    end

    def license
      if from_git?
        return nil
      end
      Utils::download_license(@name, @version, @gems_url)
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

    def md5
      if from_git?
        return nil
      end
      Utils::download_md5(@name, @version, @gems_url)
    end


  end
end
