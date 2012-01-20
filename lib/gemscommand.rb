
require "gemsimple"

class GemsCommand
  attr_reader :result
  def gem_name(gem)
    pos = gem.rindex(".gem")
    if ! pos then
      return gem
    end
    name = gem[0...pos]
    pos = name.rindex("-")
    if ! pos then
      return gem
    end
    return name[0...pos]
  end

  def gem_version(gem)
    pos = gem.rindex(".gem")
    if ! pos then
      return -1
    end
    name = gem[0...pos]
    pos = name.rindex("-")
    if ! pos then
      return -1
    end
    pos = pos + 1
    return name[pos..-1]
  end

  def execute
  end
end

