require 'rubygems'
require 'open-uri'
require 'gems-status/checkers/gem_checker'
require 'gems-status/utils'

module GemsStatus

  class ExistsInUpstream < GemChecker
    def check?(gem)
      Utils::log_debug("Looking for #{gem.name}")
      result = nil
      gem_uri = "#{gem.gems_url}/#{gem.name}-#{gem.version}.gem" 
      begin
        source = open(gem_uri)
        return true
      rescue
        return false
      end
    end
    def description
      "This gem does not exist in upstream: "
    end
  end

end
