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
      Utils::log_error(@name, "I do not know when #{@name} was released")
      nil
    end

  end
end
