require 'rubygems/format'
require 'rubygems/old_format'
require 'open-uri'
require 'gems-status/gem_checker'

class NotRailsChecker < GemChecker
  RAILS_GEMS = ["rails", "railties","activesupport"]
  def check?(gem)
    return false if !gem.dependencies 
    gem.dependencies.each do |dep|
      if RAILS_GEMS.include?(dep.name)
        return false
      end
    end
    return true
    end

  def description
    "This gem depends on rails or could not get spec: "
  end
end

