require 'rubygems'
require 'open-uri'
require 'gems-status/checkers/gem_checker'
require 'gems-status/utils'

module GemsStatus

  class IsRubygems < GemChecker

    def initialize(configuration)
      @md5 = nil
      @gem_md5 = nil
      super configuration
    end

    def check?(gem)
      Utils::log_debug("Looking for #{gem.name}")
      result = nil
      gem_uri = "http://rubygems.org/downloads/#{gem.name}-#{gem.version}.gem" 
      @md5 = Utils::download_md5(gem.name, gem.version, "http://rubygems.org/downloads")
      @gem_md5 = gem.md5
      !@md5 && !@gem_md5 && @gem_md5== @md5
    end
    
    def description
      if !@md5
        "This gem does not exist in rubygems.org "
      elsif !@gem_md5
        "This gem does not exist in your server"
      elsif @md5 != @gem_md5
        "This gem has a different md5sum than in rubygems.org\nrubygems: #{@md5} your server #{@gem_md5}"
      end
    end
  end

end
