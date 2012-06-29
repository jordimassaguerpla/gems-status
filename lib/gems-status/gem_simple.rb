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

  #TODO: write a test for this
  def depends?(gem)
    if !@dependencies
      Utils::log_error(@name, "trying to get depends on a gem that has no info on dependencies #{@name} depends #{gem.name}")
      return false
    end
    @dependencies.each do |dep|
      return true if dep.name == gem.name
    end
    return false
  end

  #TODO: write a test for this
  def merge_deps(gem)
    if !@dependencies || !gem.dependencies
      Utils::log_error(@name, "trying to merge depends on a gem that has no info on dependencies #{@name} merge #{gem.name}")
      return false
    end
    changes = false
    gem.dependencies.each do |dep|
      if !@dependencies.include?(dep)
        changes = true
        @dependencies << dep
        Utils::log_debug("adding #{dep} to dependencies")
      end
    end
    return changes
  end

  def from_git?
    return @gems_url && @gems_url.start_with?("git://")
  end

end

